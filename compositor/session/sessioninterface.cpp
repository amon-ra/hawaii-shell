/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
 *
 * Author(s):
 *    Pier Luigi Fiorini
 *
 * $BEGIN_LICENSE:GPL3-HAWAII$
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; version 3 or any later version accepted
 * by Pier Luigi Fiorini, which shall act as a proxy defined in Section 14
 * of version 3 of the license.
 *
 * Any modifications to this file must keep this entire header intact.
 *
 * The interactive user interfaces in modified source and object code
 * versions of this program must display Appropriate Legal Notices,
 * as required under Section 5 of the GNU General Public License version 3.
 *
 * In accordance with Section 7(b) of the GNU General Public License
 * version 3, these Appropriate Legal Notices must retain the display of the
 * "Powered by Hawaii" logo.  If the display of the logo is not reasonably
 * feasible for technical reasons, the Appropriate Legal Notices must display
 * the words "Powered by Hawaii".
 *
 * In accordance with Section 7(c) of the GNU General Public License
 * version 3, modified source and object code versions of this program
 * must be marked in reasonable ways as different from the original version.
 *
 * In accordance with Section 7(d) of the GNU General Public License
 * version 3, neither the "Hawaii" name, nor the name of any project that is
 * related to it, nor the names of its contributors may be used to endorse or
 * promote products derived from this software without specific prior written
 * permission.
 *
 * In accordance with Section 7(e) of the GNU General Public License
 * version 3, this license does not grant any license or rights to use the
 * "Hawaii" name or logo, nor any other trademark.
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * $END_LICENSE$
 ***************************************************************************/

#include "authenticator.h"
#include "sessioninterface.h"
#include "sessionmanager.h"

/*
 * CustomAuthenticator
 */

class CustomAuthenticator : public QObject
{
public:
    CustomAuthenticator(SessionInterface *parent, const QJSValue &callback)
        : m_parent(parent)
        , m_callback(callback)
        , m_succeded(false)
    {
        connect(m_parent->m_authenticator, &Authenticator::authenticationSucceded, this, [=] {
            m_succeded = true;
            authenticate();
        });
        connect(m_parent->m_authenticator, &Authenticator::authenticationFailed, this, [=] {
            m_succeded = false;
            authenticate();
        });
        connect(m_parent->m_authenticator, &Authenticator::authenticationError, this, [=] {
            m_succeded = false;
            authenticate();
        });
    }

private:
    SessionInterface *m_parent;
    QJSValue m_callback;
    bool m_succeded;

private Q_SLOTS:
    void authenticate() {
        if (m_callback.isCallable())
            m_callback.call(QJSValueList() << m_succeded);

        m_parent->m_authRequested = false;

        if (m_succeded)
            m_parent->sessionManager()->setLocked(false);

        deleteLater();
    }
};

/*
 * SessionInterface
 */

SessionInterface::SessionInterface(SessionManager *sm, QObject *parent)
    : QObject(parent)
    , m_sessionManager(sm)
    , m_authenticator(new Authenticator)
    , m_authenticatorThread(new QThread(this))
    , m_authRequested(false)
{
    // Authenticate in a separate thread
    m_authenticator->moveToThread(m_authenticatorThread);
    m_authenticatorThread->start();

    // Relay signals
    connect(m_sessionManager, &SessionManager::lockedChanged, this, [this](bool locked) {
        if (locked)
            Q_EMIT sessionLocked();
        else
            Q_EMIT sessionUnlocked();
    });
}

SessionInterface::~SessionInterface()
{
    m_authenticatorThread->quit();
    m_authenticatorThread->wait();
    m_authenticator->deleteLater();
}

bool SessionInterface::canLock() const
{
    return m_sessionManager->canLock();
}

bool SessionInterface::canStartNewSession() const
{
    return m_sessionManager->canStartNewSession();
}

bool SessionInterface::canLogOut() const
{
    return m_sessionManager->canLogOut();
}

bool SessionInterface::canPowerOff() const
{
    return m_sessionManager->canPowerOff();
}

bool SessionInterface::canRestart() const
{
    return m_sessionManager->canRestart();
}

bool SessionInterface::canSuspend() const
{
    return m_sessionManager->canSuspend();
}

bool SessionInterface::canHibernate() const
{
    return m_sessionManager->canHibernate();
}

bool SessionInterface::canHybridSleep() const
{
    return m_sessionManager->canHybridSleep();
}

void SessionInterface::lockSession()
{
    m_sessionManager->lockSession();
}

void SessionInterface::unlockSession(const QString &password, const QJSValue &callback)
{
    if (m_authRequested)
        return;

    (void)new CustomAuthenticator(this, callback);
    QMetaObject::invokeMethod(m_authenticator, "authenticate", Q_ARG(QString, password));
    m_authRequested = true;
}

void SessionInterface::startNewSession()
{
    m_sessionManager->startNewSession();
}

void SessionInterface::activateSession(int index)
{
    m_sessionManager->activateSession(index);
}

void SessionInterface::requestLogOut()
{
    if (!canLogOut())
        return;
    Q_EMIT logOutRequested();
}

void SessionInterface::requestPowerOff()
{
    if (!canPowerOff())
        return;
    Q_EMIT powerOffRequested();
}

void SessionInterface::requestRestart()
{
    if (!canRestart())
        return;
    Q_EMIT restartRequested();
}

void SessionInterface::requestSuspend()
{
    if (!canSuspend())
        return;
    Q_EMIT suspendRequested();
}

void SessionInterface::requestHibernate()
{
    if (!canHibernate())
        return;
    Q_EMIT hibernateRequested();
}

void SessionInterface::requestHybridSleep()
{
    if (!canHybridSleep())
        return;
    Q_EMIT hybridSleepRequested();
}

void SessionInterface::cancelShutdownRequest()
{
    Q_EMIT shutdownRequestCanceled();
}

void SessionInterface::logOut()
{
    m_sessionManager->logOut();
}

void SessionInterface::powerOff()
{
    m_sessionManager->powerOff();
}

void SessionInterface::restart()
{
    m_sessionManager->restart();
}

void SessionInterface::suspend()
{
    m_sessionManager->suspend();
}

void SessionInterface::hibernate()
{
    m_sessionManager->hibernate();
}

void SessionInterface::hybridSleep()
{
    m_sessionManager->hybridSleep();
}

#include "moc_sessioninterface.cpp"
