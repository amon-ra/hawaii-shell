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

import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.0
import Hawaii.Components 1.0 as Components
import Hawaii.Themes 1.0 as Themes
import org.hawaii.hardware 0.1

Item {
    property var battery

    RowLayout {
        anchors {
            fill: parent
            margins: Themes.Units.largeSpacing
        }
        spacing: Themes.Units.smallSpacing

        Components.Icon {
            id: icon
            width: Themes.Units.iconSizes.large
            height: width
            color: Themes.Theme.palette.panel.textColor
            cache: false

            Layout.alignment: Qt.AlignTop
        }

        ColumnLayout {
            spacing: Themes.Units.smallSpacing

            Label {
                id: chargeStateLabel
                color: Themes.Theme.palette.panel.textColor

                Layout.fillWidth: true
            }

            RowLayout {
                spacing: Themes.Units.smallSpacing

                ProgressBar {
                    id: chargeProgress
                    minimumValue: 0
                    maximumValue: 100
                    value: battery ? battery.chargePercent : 0

                    Layout.fillWidth: true
                }

                Text {
                    renderType: Text.NativeRendering
                    text: (battery ? battery.chargePercent : 0) + "%"
                    color: Themes.Theme.palette.panel.textColor
                }

                Layout.fillWidth: true
            }

            GridLayout {
                rows: battery && battery.powerSupply ? 2 : 4
                columns: 2
                opacity: 0.6
                visible: battery !== null

                Text {
                    renderType: Text.NativeRendering
                    color: Themes.Theme.palette.panel.textColor
                    text: qsTr("Time To Empty")
                }

                Text {
                    renderType: Text.NativeRendering
                    color: Themes.Theme.palette.panel.textColor
                    // TODO: Convert to time
                    text: battery ? battery.timeToEmpty : 0
                    horizontalAlignment: Qt.AlignRight
                }

                Text {
                    renderType: Text.NativeRendering
                    color: Themes.Theme.palette.panel.textColor
                    text: qsTr("Capacity")
                }

                Text {
                    renderType: Text.NativeRendering
                    color: Themes.Theme.palette.panel.textColor
                    text: (battery ? battery.capacity : 0) + "%"
                    horizontalAlignment: Qt.AlignRight
                }

                Text {
                    renderType: Text.NativeRendering
                    color: Themes.Theme.palette.panel.textColor
                    text: qsTr("Vendor")
                    visible: battery && battery.powerSupply
                }

                Text {
                    renderType: Text.NativeRendering
                    color: Themes.Theme.palette.panel.textColor
                    text: battery ? battery.vendor : qsTr("n.a.")
                    horizontalAlignment: Qt.AlignRight
                    visible: battery && battery.powerSupply
                }

                Text {
                    renderType: Text.NativeRendering
                    color: Themes.Theme.palette.panel.textColor
                    text: qsTr("Model")
                    visible: battery && battery.powerSupply
                }

                Text {
                    renderType: Text.NativeRendering
                    color: Themes.Theme.palette.panel.textColor
                    text: battery ? battery.product : qsTr("n.a.")
                    horizontalAlignment: Qt.AlignRight
                    visible: battery && battery.powerSupply
                }

                Layout.fillWidth: true
                Layout.fillHeight: true
            }

            Layout.fillWidth: true
        }
    }

    Connections {
        target: battery
        onChargePercentChanged: setIconName()
        onChargeStateChanged: setChargeState()
    }

    function setIconName() {
        var total = battery.chargePercent;
        if (total < 5)
            icon.iconName = "battery-empty-symbolic"
        else if (total < 20)
            icon.iconName = "battery-low-symbolic";
        else if (total < 40)
            icon.iconName = "battery-caution-symbolic";
        else if (total < 80)
            icon.iconName = "battery-good-symbolic";
        else
            icon.iconName = "battery-full-symbolic";
    }

    function setChargeState() {
        var state = battery.chargeState;
        switch (state) {
        case Battery.Charging:
            chargeStateLabel.text = qsTr("Charging");
            break;
        case Battery.Discharging:
            chargeStateLabel.text = qsTr("Discharging");
            break;
        case Battery.FullyCharged:
            chargeStateLabel.text = qsTr("Fully charged");
            break;
        default:
            chargeStateLabel.text = qsTr("Stable");
            break;
        }
    }

    Component.onCompleted: {
        setIconName();
        setChargeState();
    }
}
