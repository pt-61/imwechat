import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import QtQuick.Dialogs

Rectangle {
    id: edit

    property var undoStack: []
    property var redoStack: []

    FileDialog {
        id: fileDialog
        title: "选择图片"
        nameFilters: ["Images (*.png *.jpg *.jpeg *.bmp)"]
        onAccepted: {
            imagesModel.append({"source": fileDialog.fileUrl})
        }
    }

    ListModel {
        id: imagesModel
    }

    ScrollView {
        anchors.fill: parent

        Column {
            width: parent.width
            spacing: 10

            // 文本编辑区域
            TextArea {
                id: editor
                width: parent.width
                wrapMode: Text.Wrap
                placeholderText: "请输入文本..."
                focus: true

                // 初始化为1行
                height: Math.max(contentHeight, 30)
                onTextChanged: {
                    height = Math.max(contentHeight, 30)
                    undoStack.push(text)
                }

                // 允许粘贴
                Keys.onPressed: {
                    if (event.matches(StandardKey.Paste)) {
                        event.accepted = true
                    }
                }

                // 撤回和重做
                Keys.onPressed: {
                    if (event.matches(StandardKey.Undo)) {
                        event.accepted = true
                        if (undoStack.length > 1) {
                            redoStack.push(undoStack.pop())
                            text = undoStack[undoStack.length-1]
                        }
                    } else if (event.matches(StandardKey.Redo)) {
                        event.accepted = true
                        if (redoStack.length > 0) {
                            text = redoStack.pop()
                            undoStack.push(text)
                        }
                    } else if (event.matches(StandardKey.Save)) {
                        event.accepted = true
                        console.log("保存内容:", text)
                        // 这里可以触发实际保存逻辑
                    }
                }
            }

            // 导入图片按钮
            Button {
                text: "导入图片"
                onClicked: fileDialog.open()
            }

            // 图片展示GridView
            GridView {
                id: gridView
                width: parent.width
                height: Math.min(200, contentHeight) // 最多显示200px
                model: imagesModel
                cellWidth: 100
                cellHeight: 100

                delegate: Rectangle {
                    width: 100
                    height: 100
                    border.color: "gray"
                    radius: 5

                    Image {
                        anchors.fill: parent
                        anchors.margins: 2
                        source: model.source
                        fillMode: Image.PreserveAspectFit
                    }
                }
            }
        }
    }
}
