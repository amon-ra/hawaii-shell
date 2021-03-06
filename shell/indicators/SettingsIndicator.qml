/****************************************************************************
 * This file is part of Hawaii.
 *
 * Copyright (C) 2012-2015 Pier Luigi Fiorini <pierluigi.fiorini@gmail.com>
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

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.3
import Hawaii.Controls 1.0 as Controls
import Hawaii.Themes 1.0 as Themes
import ".."

Indicator {
    name: "settings"
    iconName: "preferences-system-symbolic"
    component: Component {
        ColumnLayout {
            spacing: Themes.Units.largeSpacing

            Controls.Heading {
                text: qsTr("Settings")
                color: Themes.Theme.palette.panel.textColor
            }

            Controls.Heading {
                text: qsTr("Size")
                color: Themes.Theme.palette.panel.textColor
                level: 3
            }

            Row {
                spacing: Themes.Units.smallSpacing

                ExclusiveGroup {
                    id: sizeGroup
                }

                ToolButton {
                    text: qsTr("Small")
                    checkable: true
                    checked: compositorRoot.screenView.panel.size === Themes.Units.iconSizes.medium
                    exclusiveGroup: sizeGroup
                    onClicked: compositorRoot.screenView.panel.size = Themes.Units.iconSizes.medium
                }

                ToolButton {
                    text: qsTr("Medium")
                    checkable: true
                    checked: compositorRoot.screenView.panel.size === Themes.Units.iconSizes.large
                    exclusiveGroup: sizeGroup
                    onClicked: compositorRoot.screenView.panel.size = Themes.Units.iconSizes.large
                }

                ToolButton {
                    text: qsTr("Large")
                    checkable: true
                    checked: compositorRoot.screenView.panel.size === Themes.Units.iconSizes.huge
                    exclusiveGroup: sizeGroup
                    onClicked: compositorRoot.screenView.panel.size = Themes.Units.iconSizes.huge
                }
            }

            /*
            Controls.Heading {
                text: qsTr("Position")
                color: Themes.Theme.palette.panel.textColor
                level: 3
            }

            Row {
                spacing: Themes.Units.smallSpacing

                ExclusiveGroup {
                    id: posGroup
                }

                ToolButton {
                    text: qsTr("Left")
                    iconName: "align-horizontal-left-symbolic"
                    checkable: true
                    checked: compositorRoot.screenView.panel.alignment === Qt.AlignLeft
                    exclusiveGroup: posGroup
                    onClicked: compositorRoot.screenView.panel.alignment = Qt.AlignLeft
                }

                ToolButton {
                    text: qsTr("Top")
                    iconName: "align-horizontal-top-symbolic"
                    checkable: true
                    checked: compositorRoot.screenView.panel.alignment === Qt.AlignTop
                    exclusiveGroup: posGroup
                    onClicked: compositorRoot.screenView.panel.alignment = Qt.AlignTop
                }

                ToolButton {
                    text: qsTr("Right")
                    iconName: "align-horizontal-right-symbolic"
                    checkable: true
                    checked: compositorRoot.screenView.panel.alignment === Qt.AlignRight
                    exclusiveGroup: posGroup
                    onClicked: compositorRoot.screenView.panel.alignment = Qt.AlignRight
                }

                ToolButton {
                    text: qsTr("Bottom")
                    iconName: "align-horizontal-bottom-symbolic"
                    checkable: true
                    checked: compositorRoot.screenView.panel.alignment === Qt.AlignBottom
                    exclusiveGroup: posGroup
                    onClicked: compositorRoot.screenView.panel.alignment = Qt.AlignBottom
                }
            }
            */

            Item {
                Layout.fillHeight: true
            }
        }
    }
}
