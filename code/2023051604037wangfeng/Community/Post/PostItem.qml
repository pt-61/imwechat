/*
  帖子delegate
*/
import QtQuick

import "../User"
import "../Common"

Rectangle{
  id: postItem
  property string avatar: "../picture/default/headPortrait.jpg"
  required property string name
  required property string socialName
  required property string content

  // required property date postDate

  required property int commentNum
  required property int shareNum
  required property int likesNum
  required property int collectNum

  signal clicked
  // other photo

  property int maxLines: 10
  property int textHeight: 0


  anchors.left: parent.left;  anchors.leftMargin: parent.width / 16
  anchors.right: parent.right;anchors.rightMargin: parent.width / 16
  height: 10 + userName.height + 4 + postContent.height + 20 + 24 + 6

  MouseArea {
    anchors.fill: parent
    hoverEnabled: true
    onEntered:
        parent.color = "#f6f6f6"
    onExited:
        parent.color = "white"
    onClicked: parent.clicked()
  }

  Avatar {
    id: av
    x: 10
    y: 10

    avatar: parent.avatar
  }

  Text {
    id: userName
    y: 10
    anchors.left: av.right
    anchors.leftMargin: 8

    text: name
    font.pixelSize: 16
    font.bold: true
    wrapMode: Text.WordWrap
  }


  Text {
    id: social
    y: 10
    anchors.left: userName.right
    anchors.leftMargin: 4

    text: socialName
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
    id: postContent
    anchors.left: userName.left
    anchors.top: userName.bottom
    anchors.topMargin: 4
    width: parent.width-60
    maximumLineCount: 10

    text: content
    wrapMode: Text.Wrap
    color: "#606060"
    font.pixelSize: 14
    elide: Text.ElideRight
  }

///////////////////  data ///////////////////
  Icon {
    id: commentIcon
    anchors.left: parent.left;  anchors.leftMargin: parent.width / 32
    anchors.bottom: parent.bottom;  anchors.bottomMargin: 5
    // anchors.top: postContent.bottom;    anchors.topMargin: 20

    ico:"comments.png"
  }
  Text {
    anchors.left: commentIcon.right
    anchors.leftMargin: 2
    anchors.verticalCenter: commentIcon.verticalCenter

    text: commentNum
  }

  Icon {
    id: shareIcon
    anchors.left: parent.left; anchors.leftMargin: parent.width / 32 * 10
    anchors.verticalCenter: commentIcon.verticalCenter

    ico:"share.png"
  }
  Text {
    anchors.left: shareIcon.right
    anchors.leftMargin: 2
    anchors.verticalCenter: commentIcon.verticalCenter

    text: shareNum
  }

  Icon {
    id: likesIcon
    anchors.left: parent.left; anchors.leftMargin: parent.width / 32 * 20
    anchors.verticalCenter: commentIcon.verticalCenter

    ico:"likes.png"
  }
  Text {
    anchors.left: likesIcon.right
    anchors.leftMargin: 2
    anchors.verticalCenter: commentIcon.verticalCenter

    text: likesNum
  }

  Icon {
    id: collectIcon
    anchors.left: parent.left; anchors.leftMargin: parent.width / 32 * 28
    anchors.verticalCenter: commentIcon.verticalCenter

    ico:"booktag.png"
  }
  Text {
    anchors.left: collectIcon.right
    anchors.leftMargin: 2
    anchors.verticalCenter: commentIcon.verticalCenter

    text: collectNum
  }


///////////////////  operation ///////////////////
  Icon {
    id: ellipsis
    anchors.verticalCenter: userName.verticalCenter
    anchors.right: parent.right;  anchors.rightMargin: 20
    ico: "ellipsis.png"
  }

  Icon {
    id: report
    anchors.verticalCenter: ellipsis.verticalCenter
    anchors.right: ellipsis.left; anchors.rightMargin: 10
    ico: "report.png"
  }

  Rectangle {
    id: cutLine
    width: parent.width
    height: 1
    anchors.bottom: parent.bottom
    color: "#f0f0f0"
  }

}


