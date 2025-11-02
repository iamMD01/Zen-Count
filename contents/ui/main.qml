import QtQuick 2.15
import QtQuick.Layouts 1.15
import QtGraphicalEffects 1.15
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.plasmoid 2.0
import org.kde.plasma.components 3.0 as PlasmaComponents3

Item {
    id: root

    width: units.gridUnit * 20
    height: units.gridUnit * 20

    Plasmoid.backgroundHints: PlasmaCore.Types.NoBackground
    Plasmoid.preferredRepresentation: Plasmoid.fullRepresentation

    property var counters: []
    property int currentCounterIndex: 0
    property var currentCounter: counters.length > 0 ? counters[currentCounterIndex] : null

    Component.onCompleted: {
        loadCounters()

        if (counters.length === 0) {
            counters = [{
                title: "Year Ends In",
                endDate: new Date(2025, 11, 31),
                gradient1: "#ff4545",
                gradient2: "#ff8a00",
                gradient3: "#ffd000",
                textColor: "#ffffff",
                transparent: false
            }]
            saveCounters()
        }

        updateCountdown()

        plasmoid.configuration.valueChanged.connect(function(key, value) {
            if (key === "countersData" || key === "currentIndex") {
                loadCounters()
                updateCountdown()
            }
        })
    }

    Timer {
        interval: 60000
        running: true
        repeat: true
        onTriggered: updateCountdown()
    }

    property int daysLeft: 0
    property real percentLeft: 0

    function updateCountdown() {
        if (!currentCounter) return

        var now = new Date()
        now.setHours(0, 0, 0, 0)

        var end = new Date(currentCounter.endDate)
        end.setHours(23, 59, 59, 999)

        var diff = end.getTime() - now.getTime()
        daysLeft = Math.max(0, Math.ceil(diff / (1000 * 60 * 60 * 24)))

        var yearStart = new Date(now.getFullYear(), 0, 1)
        yearStart.setHours(0, 0, 0, 0)
        var yearEnd = new Date(now.getFullYear(), 11, 31, 23, 59, 59)

        var totalDays = Math.ceil((yearEnd - yearStart) / (1000 * 60 * 60 * 24)) + 1
        var daysPassed = Math.ceil((now - yearStart) / (1000 * 60 * 60 * 24))
        var daysRemaining = totalDays - daysPassed

        percentLeft = Math.max(0, ((daysRemaining / totalDays) * 100).toFixed(1))
    }

    function formatDate(date) {
        var d = new Date(date)
        var months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec']
        return d.getDate() + ' ' + months[d.getMonth()] + ' ' + d.getFullYear()
    }

    function saveCounters() {
        plasmoid.configuration.countersData = JSON.stringify(counters)
        plasmoid.configuration.currentIndex = currentCounterIndex
    }

    function loadCounters() {
        try {
            var data = plasmoid.configuration.countersData
            if (data && data.length > 0) {
                var newCounters = JSON.parse(data)
                counters = newCounters
                var newIndex = plasmoid.configuration.currentIndex || 0
                if (newIndex >= counters.length) {
                    newIndex = 0
                }
                currentCounterIndex = newIndex
            }
        } catch (e) {
            console.log("Error loading counters:", e)
        }
    }

    Plasmoid.fullRepresentation: Item {
        Layout.preferredWidth: units.gridUnit * 20
        Layout.preferredHeight: units.gridUnit * 20
        Layout.minimumWidth: units.gridUnit * 15
        Layout.minimumHeight: units.gridUnit * 15

        Rectangle {
            id: background
            anchors.fill: parent
            radius: units.gridUnit * 3
            opacity: currentCounter && currentCounter.transparent ? 0.2 : 1.0

            LinearGradient {
                anchors.fill: parent
                start: Qt.point(0, 0)
                end: Qt.point(parent.width, parent.height)
                gradient: Gradient {
                    GradientStop {
                        position: 0.0
                        color: currentCounter ? currentCounter.gradient1 : "#ff4545"
                    }
                    GradientStop {
                        position: 0.5
                        color: currentCounter ? currentCounter.gradient2 : "#ff8a00"
                    }
                    GradientStop {
                        position: 1.0
                        color: currentCounter ? (currentCounter.gradient3 || currentCounter.gradient2) : "#ffd000"
                    }
                }
            }
        }

        DropShadow {
            anchors.fill: background
            source: background
            horizontalOffset: 0
            verticalOffset: 4
            radius: 20
            samples: 17
            color: "#80000000"
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: units.gridUnit * 2
            spacing: units.gridUnit * 0.5

            RowLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop

                PlasmaComponents3.Label {
                    id: titleLabel
                    Layout.fillWidth: true
                    text: currentCounter ? currentCounter.title : "Year Ends In"
                    font.pixelSize: units.gridUnit * 1.4
                    font.weight: Font.Bold
                    color: currentCounter ? currentCounter.textColor : "#ffffff"
                    wrapMode: Text.Wrap
                    maximumLineCount: 2
                    horizontalAlignment: Text.AlignLeft
                }

                PlasmaCore.SvgItem {
                    id: settingsIcon
                    Layout.preferredWidth: units.gridUnit * 2
                    Layout.preferredHeight: units.gridUnit * 2

                    svg: PlasmaCore.Svg {
                        imagePath: "widgets/configuration-icons"
                    }
                    elementId: "configure"

                    ColorOverlay {
                        anchors.fill: parent
                        source: settingsIcon
                        color: currentCounter ? currentCounter.textColor : "#ffffff"
                    }

                    MouseArea {
                        anchors.fill: parent
                        anchors.margins: -units.gridUnit * 0.5
                        hoverEnabled: true
                        cursorShape: Qt.PointingHandCursor
                        onClicked: {
                            plasmoid.action("configure").trigger()
                        }
                        onEntered: {
                            settingsIcon.opacity = 0.7
                        }
                        onExited: {
                            settingsIcon.opacity = 1.0
                        }
                    }

                    Behavior on opacity {
                        NumberAnimation { duration: 200 }
                    }
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                PlasmaComponents3.Label {
                    id: daysNumberLabel
                    anchors.centerIn: parent
                    text: root.daysLeft.toString()
                    font.pixelSize: Math.min(parent.width * 0.6, parent.height * 0.85)
                    font.weight: Font.Black
                    color: currentCounter ? currentCounter.textColor : "#ffffff"
                }

                DropShadow {
                    anchors.fill: daysNumberLabel
                    source: daysNumberLabel
                    horizontalOffset: 0
                    verticalOffset: 4
                    radius: 30
                    samples: 16
                    color: "#40000000"
                }
            }

            ColumnLayout {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignBottom
                spacing: 0

                PlasmaComponents3.Label {
                    text: "Days & " + root.percentLeft + "% Left"
                    font.pixelSize: units.gridUnit * 1.3
                    font.weight: Font.Bold
                    color: currentCounter ? currentCounter.textColor : "#ffffff"
                }

                PlasmaComponents3.Label {
                    text: currentCounter ? formatDate(currentCounter.endDate) : "31 Dec 2025"
                    font.pixelSize: units.gridUnit * 1.3
                    font.weight: Font.Bold
                    color: currentCounter ? currentCounter.textColor : "#ffffff"
                }
            }
        }
    }
}
