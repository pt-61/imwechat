import QtQuick
import QtQuick.Controls

ApplicationWindow {
    id:window1
    width: 640
    height: 480
    visible: true
    title: qsTr("Hello World")

  Logdialog{
       id:log1
       anchors.centerIn: parent
}

   Register{
        id:re1
        anchors.centerIn: parent
        visible: false
   }

/*
  Loader{
     source: "TcpClient.qml"
     anchors.fill: parent
     visible: true
  }
*/
   Connections{
       target: log1
       function onZucebutton(){
           log1.visible=false
          re1.visible=true
        }
   }
   Connections{
       target:register1
         function onRegisterSuccess(){
            log1.visible = true;
              re1.visible = false;
         }
   }

}
