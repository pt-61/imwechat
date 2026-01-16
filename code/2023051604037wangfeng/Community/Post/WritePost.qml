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

    signal post(var p)
    signal back

    BackHeader {
      id: header
      title: "发帖"
      onBack: parent.back()
    }
    onBack:
        StackView.view.pop()

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
            font.pixelSize: 18
        }
        TextField {
            id: title
            anchors.left: titleLabel.right
            anchors.right: parent.right;    anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            maximumLength: 48
            focus: true

            background:Rectangle {
                radius: 4            // 圆角
                color: "#fafafa"     // 背景色
            }

            font.pixelSize: 18
            font.bold: true
            placeholderText: "不超过48个字"
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
      height: 40
      color: parent.color

      Icon {
        anchors.left: parent.left;
        anchors.verticalCenter: parent.verticalCenter
        height: 36
        width: 36
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
      model: imgModel
      delegate: picture
      Component.onCompleted: {
        cellWidth = width / 3
        cellHeight = cellWidth
        imgSize = cellHeight - 10
      }
    }

    Suspender {
        id: spd
        parentItem: parent
        str: "发布"
        onClicked: checkContent()

        onYChanged: {
          y = (y < 50) ? 50 : y
        }
    }

    ListModel {
      id: imgModel
    }

    Component {
      id: picture

      Rectangle {
        id: imgWrapper
        required property int index
        required property string img

        height: imgSize; width: imgSize
        radius: width / 8
        border.color: "#f8f8f8"
        border.width: 1
        clip: true

        Image {
          anchors.fill: parent
          sourceSize.width: imgSize
          sourceSize.height: imgSize
          fillMode: Image.PreserveAspectFit
          smooth: true

          source: parent.img
        }

        Icon {
          anchors.top: parent.top;  anchors.topMargin: 10
          anchors.right: parent.right;  anchors.rightMargin: 10
          height: parent.height / 8
          width: height

          ico: "cancel.png"

          onClicked: imgModel.remove(parent.index)
        }
      }
    }

    Component.onCompleted: {
        spd.open()
    }

    property string imgs
    function checkContent()
    {
      if (title.length === 0 && content.length === 0 && imgModel.count === 0)
      {
        console.log("Empty")
        return
      }

      imgs = ""
      if (imgModel.count !== 0)
      {
        imgs += imgModel.get(0).img
        if (imgModel.count > 1)
          for (var i=1; i<imgModel.count; ++i)
          {
            imgs += ","
            var tmp = imgModel.get(i)
            imgs += tmp.img
          }
      }
      sure.open()
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
          if (selectedFiles.length > 15)  // 不超过 15 张图片
            return

          // 不能选重复的图片
          for (let i = 0; i < selectedFiles.length; ++i) {
            var tmp = selectedFiles[i].toString()
            var dup = false
            for (let j=0; j<imgModel.count; ++j)
              if (imgModel.get(j).img === tmp)
              {
                dup = true; break
              }
            if (!dup)
              imgModel.append({
                  img: tmp
              })
          }
        }
    }

    Dialog {
      id: sure

      x: parent.width/2 - sure.width/2
      y: parent.height/2 - sure.height/2

      modal: true
      header: Rectangle {
        height: 20
        Text {
          anchors.top: parent.top;  anchors.topMargin: 10
          anchors.horizontalCenter: parent.horizontalCenter
          font.bold: true
          font.pixelSize: 16
          color: "#404040"
          text: qsTr("发帖")
        }
      }

      contentItem: Item {
        implicitHeight: 50

        Text {
            anchors.centerIn: parent
            font.pixelSize: 14
            color: "#404040"
            text: qsTr("确认发送帖子？")
        }
      }

      // standardButtons: Dialog.Ok | Dialog.Cancel
      footer: DialogButtonBox {
        Button {
          implicitHeight: 40
          text: "确认"
          DialogButtonBox.buttonRole: DialogButtonBox.AcceptRole
          onClicked: sure.accept()
        }

        Button {
          implicitHeight: 40
          text: "取消"
          DialogButtonBox.buttonRole: DialogButtonBox.RejectRole
          onClicked: sure.reject()
        }
      }

      onAccepted: {
        post({
          title: title.text,
          content: content.text,
          imgs: imgs
        })
        back()
      }

      background: Rectangle {
          color: "white"
          radius: 6
          clip: true
      }
    }
}
