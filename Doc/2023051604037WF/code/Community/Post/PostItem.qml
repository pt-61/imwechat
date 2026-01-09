/*
  帖子delegate
*/
import QtQuick
import "../User"

Rectangle{
  id: postItem
  required property string avatarImg
  required property string userName
  required property string userEmail
  required property string postContent

  // required property var tags
  // required property date postDate

  required property int commentNum
  required property int shareNum
  required property int likesNum

  signal clicked
  // other photo

  property int maxLines: 10
  property int textHeight: 0


  width: 450
  height: 10 + name.height + 4 + content.height + 4 + 24 + 4

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
    anchors.leftMargin: 8

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
    width: parent.width-60
    maximumLineCount: 10

    text: postContent
    wrapMode: Text.Wrap
    color: "#606060"
    font.pixelSize: 14
    elide: Text.ElideRight
  }

///////////////////  data ///////////////////
  Icon {
    id: commentIcon
    anchors.left: parent.left;  anchors.leftMargin: 20
    anchors.bottom: parent.bottom;  anchors.bottomMargin: 4
    anchors.top: content.bottom;    anchors.topMargin: 4

    ico:"picture/icons/comments.png"
  }
  Text {
    anchors.left: commentIcon.right
    anchors.leftMargin: 2
    anchors.verticalCenter: commentIcon.verticalCenter

    text: commentNum
  }

  Icon {
    id: shareIcon
    anchors.horizontalCenter: parent.horizontalCenter
    anchors.verticalCenter: commentIcon.verticalCenter

    ico:"picture/icons/share.png"
  }
  Text {
    anchors.left: shareIcon.right
    anchors.leftMargin: 2
    anchors.verticalCenter: commentIcon.verticalCenter

    text: shareNum
  }

  Icon {
    id: likesIcon
    anchors.right: parent.right;  anchors.rightMargin: 40
    anchors.verticalCenter: commentIcon.verticalCenter

    ico:"picture/icons/likes.png"
  }
  Text {
    anchors.left: likesIcon.right
    anchors.leftMargin: 2
    anchors.verticalCenter: commentIcon.verticalCenter

    text: likesNum
  }

  color: hover.hovered ? "#f6f6f6" : "white"
  HoverHandler {
    id: hover
  }
}


