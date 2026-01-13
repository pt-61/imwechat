/*
  编辑帖子
  帖子的标题可以没有
  帖子的内容必须至少有文本、图片、投票三者之一
  可以预设定帖子的发布时间
*/
import QtQuick
import QtQuick.Controls
import QtQuick.Dialogs
import QtQuick.Controls.Basic

import "../Common"

Rectangle {
    id: writePost

    color: "#fdfdfd"
    border.color: "#f6f6f6"
    border.width: 1

    BackHeader {
      id: header
      title: "发帖"
    }

    Rectangle {
        id: tt  // title
        anchors.top: header.bottom; anchors.topMargin: 10
        anchors.left: parent.left;  anchors.leftMargin: 1
        anchors.right: parent.right;anchors.rightMargin: 1
        color: parent.color
        height: 30

        Text {
            id: titleLabel
            anchors.left: parent.left;  anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            width: 70

            text: "标题:"
            font.pixelSize: 16
        }
        TextField {
            id: title
            anchors.left: titleLabel.right
            anchors.right: parent.right;    anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            maximumLength: 24
            focus: true

            background:Rectangle {
                radius: 4            // 圆角
                color: "#fafafa"     // 背景色
            }

            font.pixelSize: 16
            font.bold: true
            placeholderText: "不超过24个字"
        }
    }

    ScrollView {
      id: ct  // title
      property int curLineNum: 1
      property int maxLine: 10

      height: content.implicitHeight
      anchors.top: tt.bottom; anchors.topMargin: 5
      anchors.left: parent.left;  anchors.leftMargin: 20
      anchors.right: parent.right;  anchors.rightMargin: 20
      clip: true

      ScrollBar.horizontal.policy: ScrollBar.AlwaysOff
      ScrollBar.vertical.policy: ScrollBar.AlwaysOff
      Flickable {
          boundsBehavior: Flickable.StopAtBounds
      }

      contentWidth: width

      TextArea {
          id: content
          property real curHeight: curHeight = implicitHeight
          width: ct.width

          background:Rectangle {
              color: "#fbfbfb"
          }

          wrapMode: Text.Wrap
          focus: true
          font.pixelSize: 15
          font.letterSpacing: 1.5
          placeholderText: "请输入帖子内容……"
          onImplicitHeightChanged: {
            if (curHeight > implicitHeight)
            {
              ct.curLineNum--
              if (ct.curLineNum <= ct.maxLine)
                ct.height = implicitHeight
            }
            else if (curHeight < implicitHeight)
            {
              ct.curLineNum++
              if (ct.curLineNum <= ct.maxLine)
                ct.height = implicitHeight
            }
            curHeight = implicitHeight
          }
      }

      Component.onCompleted: {
        ct.curLineNum = 1
      }
    }

    signal addImage
    onAddImage: imageDialog.open()
    Rectangle {
      id: dd

      anchors.left: ct.left
      anchors.right: ct.right
      anchors.top: ct.bottom
      height: 30
      color: parent.color

      Icon {
        anchors.left: parent.left;
        anchors.verticalCenter: parent.verticalCenter
        ico: "picture.png"
        onClicked: writePost.addImage()
      }
    }

    property real imgSize
    GridView {
      id: pics
      anchors.left: ct.left;  anchors.leftMargin: 10
      anchors.right: ct.right;
      anchors.top: dd.bottom
      anchors.bottom: parent.bottom
      clip: true

      cellHeight: 170;  cellWidth: 170
      model: source
      delegate: picture
      Component.onCompleted: {
        cellWidth = width / 3
        cellHeight = cellWidth
        imgSize = cellHeight - 10
      }
    }

    ListModel {
      id: source
      // ListElement {img: "../picture/default/headPortrait.jpg"}
    }

    Component {
      id: picture

      Rectangle {
        id: imgWrapper
        required property string img

        height: imgSize; width: imgSize

        Image {
          anchors.fill: parent
          sourceSize.width: imgSize
          sourceSize.height: imgSize
          fillMode: Image.PreserveAspectFit
          smooth: true

          source: parent.img
        }
      }
    }

    FileDialog {
        id: imageDialog
        title: "选择图片"
        fileMode: FileDialog.OpenFiles       // 多选
        nameFilters: [
            "Image files (*.png *.jpg *.jpeg *.bmp *.gif)",
            "All files (*)"
        ]
        onAccepted: {
            // console.log("选择的文件:", selectedFile)
            for (let i = 0; i < selectedFiles.length; ++i) {
                source.append({
                    img: selectedFiles[i].toString()
                })
            }
        }
        onRejected: {
            console.log("取消选择")
        }
    }
}
