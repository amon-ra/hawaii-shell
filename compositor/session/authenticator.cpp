/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2015 Pier Luigi Fiorini
 *
 * Author(s):
 *    Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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

#include <security/pam_appl.h>
#include <unistd.h>
#include <pwd.h>

Authenticator::Authenticator(QObject *parent)
    : QObject(parent)
    , m_response(Q_NULLPTR)
{
}

Authenticator::~Authenticator()
{
}

void Authenticator::authenticate(const QString &password)
{
    const pam_conv conversation = { conversationHandler, this };
    pam_handle_t *handle = Q_NULLPTR;

    passwd *pwd = getpwuid(getuid());
    if (!pwd) {
        Q_EMIT authenticationError();
        return;
    }

    int retval = pam_start("su", pwd->pw_name, &conversation, &handle);
    if (retval != PAM_SUCCESS) {
        qWarning("pam_start returned %d", retval);
        Q_EMIT authenticationError();
        return;
    }

    m_response = new pam_response;
    m_response[0].resp = strdup(qPrintable(password));
    m_response[0].resp_retcode = 0;

    retval = pam_authenticate(handle, 0);
    if (retval != PAM_SUCCESS) {
        if (retval == PAM_AUTH_ERR) {
            Q_EMIT authenticationFailed();
        } else {
            qWarning("pam_authenticate returned %d", retval);
            Q_EMIT authenticationError();
        }

        return;
    }

    retval = pam_end(handle, retval);
    if (retval != PAM_SUCCESS) {
        qWarning("pam_end returned %d", retval);
        Q_EMIT authenticationError();
        return;
    }

    Q_EMIT authenticationSucceded();
}

int Authenticator::conversationHandler(int num, const pam_message **message,
                                       pam_response **response, void *data)
{
    Q_UNUSED(num);
    Q_UNUSED(message);

    Authenticator *self = static_cast<Authenticator *>(data);
    *response = self->m_response;
    return PAM_SUCCESS;
}

#include "moc_authenticator.cpp"
