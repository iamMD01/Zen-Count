import QtQuick 2.15
import QtQuick.Controls 2.15 as QQC2
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.3
import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3

ColumnLayout {
    id: configPage

    property alias cfg_countersData: countersDataField.text
    property alias cfg_currentIndex: currentIndexField.text

    spacing: units.largeSpacing

    QQC2.TextField {
        id: countersDataField
        visible: false
    }

    QQC2.TextField {
        id: currentIndexField
        visible: false
    }

    property var counters: []
    property int editingIndex: 0
    property bool isLoading: false

    Component.onCompleted: {
        loadCounters()
    }

    function loadCounters() {
        isLoading = true
        try {
            if (cfg_countersData && cfg_countersData.length > 0) {
                counters = JSON.parse(cfg_countersData)
                editingIndex = parseInt(cfg_currentIndex) || 0
                if (editingIndex >= counters.length) {
                    editingIndex = 0
                }
                loadCurrentCounter()
                updateComboModel()
            }
        } catch (e) {
            console.log("Error loading counters:", e)
        }
        isLoading = false
    }

    function updateComboModel() {
        var items = []
        for (var i = 0; i < counters.length; i++) {
            items.push((i + 1) + ". " + counters[i].title)
        }
        counterCombo.model = items
        counterCombo.currentIndex = editingIndex
    }

    function loadCurrentCounter() {
        if (isLoading) return
        if (counters.length > editingIndex) {
            isLoading = true
            var counter = counters[editingIndex]
            titleField.text = counter.title

            var d = new Date(counter.endDate)
            var month = ("0" + (d.getMonth() + 1)).slice(-2)
            var day = ("0" + d.getDate()).slice(-2)
            dateField.text = d.getFullYear() + "-" + month + "-" + day

            color1Field.text = counter.gradient1
            color2Field.text = counter.gradient2
            color3Field.text = counter.gradient3 || counter.gradient2
            textColorField.text = counter.textColor
            transparentCheck.checked = counter.transparent
            isLoading = false
        }
    }

    function saveCurrentCounter() {
        if (isLoading) return
        if (counters.length > editingIndex) {
            counters[editingIndex].title = titleField.text
            counters[editingIndex].endDate = new Date(dateField.text)
            counters[editingIndex].gradient1 = color1Field.text
            counters[editingIndex].gradient2 = color2Field.text
            counters[editingIndex].gradient3 = color3Field.text
            counters[editingIndex].textColor = textColorField.text
            counters[editingIndex].transparent = transparentCheck.checked

            saveAllCounters()
            updateComboModel()
        }
    }

    function saveAllCounters() {
        cfg_countersData = JSON.stringify(counters)
        cfg_currentIndex = editingIndex.toString()
    }

    RowLayout {
        Layout.fillWidth: true

        PlasmaComponents3.Label {
            text: "Select Counter:"
            font.bold: true
        }

        QQC2.ComboBox {
            id: counterCombo
            Layout.fillWidth: true
            onCurrentIndexChanged: {
                if (!isLoading && currentIndex !== editingIndex && currentIndex >= 0) {
                    editingIndex = currentIndex
                    loadCurrentCounter()
                    saveAllCounters()
                }
            }
        }

        PlasmaComponents3.Button {
            icon.name: "list-add"
            text: "Add"
            onClicked: {
                var newCounter = {
                    title: "New Countdown " + (counters.length + 1),
                    endDate: new Date(Date.now() + 30 * 24 * 60 * 60 * 1000),
                    gradient1: "#667eea",
                    gradient2: "#764ba2",
                    gradient3: "#764ba2",
                    textColor: "#ffffff",
                    transparent: false
                }
                counters.push(newCounter)
                editingIndex = counters.length - 1
                loadCurrentCounter()
                updateComboModel()
                saveAllCounters()
            }
        }

        PlasmaComponents3.Button {
            icon.name: "delete"
            text: "Delete"
            enabled: counters.length > 1
            onClicked: {
                if (counters.length > 1) {
                    counters.splice(editingIndex, 1)
                    if (editingIndex >= counters.length) {
                        editingIndex = counters.length - 1
                    }
                    loadCurrentCounter()
                    updateComboModel()
                    saveAllCounters()
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: theme.textColor
        opacity: 0.2
    }

    RowLayout {
        Layout.fillWidth: true
        PlasmaComponents3.Label {
            text: "Title:"
            Layout.preferredWidth: units.gridUnit * 8
        }
        QQC2.TextField {
            id: titleField
            Layout.fillWidth: true
            placeholderText: "Enter countdown title"
            onTextChanged: {
                if (!isLoading) {
                    saveCurrentCounter()
                }
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        PlasmaComponents3.Label {
            text: "End Date:"
            Layout.preferredWidth: units.gridUnit * 8
        }
        QQC2.TextField {
            id: dateField
            Layout.fillWidth: true
            placeholderText: "YYYY-MM-DD"
            onTextChanged: {
                if (!isLoading) {
                    saveCurrentCounter()
                }
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: theme.textColor
        opacity: 0.2
    }

    PlasmaComponents3.Label {
        text: "Gradient Colors:"
        font.bold: true
    }

    RowLayout {
        Layout.fillWidth: true
        spacing: units.smallSpacing

        Rectangle {
            Layout.preferredWidth: units.gridUnit * 3
            Layout.preferredHeight: units.gridUnit * 3
            color: color1Field.text
            border.color: theme.textColor
            border.width: 1
            radius: units.smallSpacing

            MouseArea {
                anchors.fill: parent
                onClicked: colorDialog1.open()
            }
        }

        QQC2.TextField {
            id: color1Field
            Layout.fillWidth: true
            text: "#ff4545"
            onTextChanged: {
                if (!isLoading) {
                    saveCurrentCounter()
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: units.gridUnit * 3
            Layout.preferredHeight: units.gridUnit * 3
            color: color2Field.text
            border.color: theme.textColor
            border.width: 1
            radius: units.smallSpacing

            MouseArea {
                anchors.fill: parent
                onClicked: colorDialog2.open()
            }
        }

        QQC2.TextField {
            id: color2Field
            Layout.fillWidth: true
            text: "#ff8a00"
            onTextChanged: {
                if (!isLoading) {
                    saveCurrentCounter()
                }
            }
        }

        Rectangle {
            Layout.preferredWidth: units.gridUnit * 3
            Layout.preferredHeight: units.gridUnit * 3
            color: color3Field.text
            border.color: theme.textColor
            border.width: 1
            radius: units.smallSpacing

            MouseArea {
                anchors.fill: parent
                onClicked: colorDialog3.open()
            }
        }

        QQC2.TextField {
            id: color3Field
            Layout.fillWidth: true
            text: "#ffd000"
            onTextChanged: {
                if (!isLoading) {
                    saveCurrentCounter()
                }
            }
        }
    }

    RowLayout {
        Layout.fillWidth: true
        PlasmaComponents3.Label {
            text: "Text Color:"
            Layout.preferredWidth: units.gridUnit * 8
        }
        Rectangle {
            Layout.preferredWidth: units.gridUnit * 3
            Layout.preferredHeight: units.gridUnit * 3
            color: textColorField.text
            border.color: theme.textColor
            border.width: 1
            radius: units.smallSpacing

            MouseArea {
                anchors.fill: parent
                onClicked: textColorDialog.open()
            }
        }
        QQC2.TextField {
            id: textColorField
            Layout.fillWidth: true
            text: "#ffffff"
            onTextChanged: {
                if (!isLoading) {
                    saveCurrentCounter()
                }
            }
        }
    }

    QQC2.CheckBox {
        id: transparentCheck
        text: "Transparent Background"
        onCheckedChanged: {
            if (!isLoading) {
                saveCurrentCounter()
            }
        }
    }

    Rectangle {
        Layout.fillWidth: true
        Layout.preferredHeight: 1
        color: theme.textColor
        opacity: 0.2
    }

    PlasmaComponents3.Label {
        text: "Gradient Presets:"
        font.bold: true
    }

    GridLayout {
        Layout.fillWidth: true
        columns: 4
        columnSpacing: units.smallSpacing
        rowSpacing: units.smallSpacing

        Repeater {
            model: [
                ["#ff4545", "#ff8a00", "#ffd000"],
                ["#667eea", "#764ba2", "#764ba2"],
                ["#f093fb", "#f5576c", "#f5576c"],
                ["#4facfe", "#00f2fe", "#00f2fe"],
                ["#43e97b", "#38f9d7", "#38f9d7"],
                ["#fa709a", "#fee140", "#fee140"],
                ["#30cfd0", "#330867", "#330867"],
                ["#a8edea", "#fed6e3", "#fed6e3"]
            ]

            delegate: Rectangle {
                Layout.preferredWidth: units.gridUnit * 4
                Layout.preferredHeight: units.gridUnit * 3
                radius: units.smallSpacing

                gradient: Gradient {
                    GradientStop { position: 0.0; color: modelData[0] }
                    GradientStop { position: 0.5; color: modelData[1] }
                    GradientStop { position: 1.0; color: modelData[2] }
                }

                MouseArea {
                    anchors.fill: parent
                    cursorShape: Qt.PointingHandCursor
                    onClicked: {
                        color1Field.text = modelData[0]
                        color2Field.text = modelData[1]
                        color3Field.text = modelData[2]
                    }
                }
            }
        }
    }

    Item {
        Layout.fillHeight: true
    }

    ColorDialog {
        id: colorDialog1
        title: "Choose Gradient Color 1"
        color: color1Field.text
        onAccepted: color1Field.text = color
    }

    ColorDialog {
        id: colorDialog2
        title: "Choose Gradient Color 2"
        color: color2Field.text
        onAccepted: color2Field.text = color
    }

    ColorDialog {
        id: colorDialog3
        title: "Choose Gradient Color 3"
        color: color3Field.text
        onAccepted: color3Field.text = color
    }

    ColorDialog {
        id: textColorDialog
        title: "Choose Text Color"
        color: textColorField.text
        onAccepted: textColorField.text = color
    }
}
