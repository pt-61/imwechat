/*
  帖子delegate
*/
import QtQuick
import "../User"

Rectangle{
  id: post
  required property string avatarImg
  required property string userName
  required property string userEmail
  required property string postContent

  // required property var tags
  required property date postDate

  required property int commentNum
  required property int shareNum
  required property int likesNum

  signal clicked
  // other photo

  property int maxLines: 10
  property int textHeight: 0


  function calculateTextHeight() {
      // 创建一个临时 Text 对象用于测量
      var temp = Qt.createQmlObject('import QtQuick 2.15; Text { wrapMode: Text.Wrap; font.pixelSize: 16; }', post)
      temp.text = postContent
      temp.width = 240   // 帖子正文内容的宽度
      temp.font.pixelSize = 16
      temp.visible = false

      // 每行高度
      var lineHeight = temp.font.pixelSize * 1.2   // 粗略估计 1.2 倍行高
      // 计算行数
      var lines = Math.ceil(temp.paintedHeight / lineHeight)
      if (lines > maxLines) lines = maxLines

      textHeight = lines * lineHeight
      temp.destroy()
  }

  Component.onCompleted: {
    calculateTextHeight()
  }

  width: 300
  height: 10 + name.height + 4 + textHeight + 4 + 24 + 4

  Avatar {
    id: avatar
    x: 10
    y: 10

    img: avatarImg
  }

  Text {
    id: name
    y: 10
    anchors.left: avatar.right
    anchors.leftMargin: 4

    text: userName
    font.pixelSize: 16
    font.bold: true
    wrapMode: Text.WordWrap
  }


  Text {
    id: email
    y: 10
    anchors.left: name.right
    anchors.leftMargin: 4

    text: userEmail
    color: "gray"
    font.pixelSize: 16
    font.bold: true
    wrapMode: Text.WordWrap
  }

///////////////////  content ///////////////////
/*
  可能包含tag或回复
  若包含tag，先展示tags，tags为蓝色，点击后，跳转到tag区
  若包含回复，回复对象的邮箱为蓝色

  若无tag和回复，展示正文内容

  可能包含图片，图片展示在最后
*/
  Text {
    id: content
    anchors.left: name.left
    anchors.top: name.bottom
    anchors.topMargin: 4
    width: 240
    height: parent.textHeight

    text: postContent
    wrapMode: Text.Wrap
    font.pixelSize: 16
    elide: Text.ElideRight
  }

///////////////////  data ///////////////////
  Rectangle {
    id: commment
    anchors.left: parent.left
    anchors.leftMargin: 30
    anchors.top: content.bottom
    anchors.topMargin: 4
    anchors.bottom: parent.bottom
    anchors.bottomMargin: 4
    height: 24
    width: 24 + 2 + commentNum.width

    Icon {
      id: commentIcon
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter

      ico:"picture/icons/comments.png"
    }
    Text {
      anchors.left: commentIcon.right
      anchors.leftMargin: 2
      anchors.verticalCenter: parent.verticalCenter

      text: commentNum
    }
  }

  Rectangle {
    id: share
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: commment.verticalCenter
    height: 24
    width: 24 + 2 + shareNum.width
    Icon {
      id: shareIcon
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter

      ico:"picture/icons/share.png"
    }
    Text {
      anchors.left: shareIcon.right
      anchors.leftMargin: 2
      anchors.verticalCenter: parent.verticalCenter

      text: shareNum
    }
  }

  Rectangle {
    id: likes
    anchors.right: parent.right
    anchors.rightMargin: 30
    anchors.verticalCenter: commment.verticalCenter
    height: 24
    width: 24 + 2 + likesNum.width
    Icon {
      id: likesIcon
      anchors.left: parent.left
      anchors.verticalCenter: parent.verticalCenter

      ico:"picture/icons/likes.png"
    }
    Text {
      anchors.left: likesIcon.right
      anchors.leftMargin: 2
      anchors.verticalCenter: parent.verticalCenter

      text: likesNum
    }
  }
}


