import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

Window {
    width: 640
    height: 480
    visible: true
    //visibility: Window.FullScreen
    visibility: Window.Maximized
    title: qsTr("Solitaire")

    Rectangle {
        id: root
        color: "green"
        anchors.fill: parent

        function isOverlapping(item1, item2) {
            return !(item1.x + item1.width <= item2.x
                     || item1.x >= item2.x + item2.width
                     || item1.y + item1.height <= item2.y
                     || item1.y >= item2.y + item2.height)
        }

        Rectangle {
            id: controls
            height: parent.width > parent.height * 1.2 ? (parent.height / 4) : (parent.height / 14)
            anchors {
                bottom: parent.bottom
                left: parent.left
                margins: parent.width > parent.height * 1.2 ? parent.width / 43 : parent.width / 42
            }
            width: parent.width > parent.height
                   * 1.2 ? root.width / 5 : root.width - parent.width / 21
            radius: 6
            z: 101
            color: "black"
            GridLayout {
                id: controlLayout
                anchors.fill: parent
                property bool isLandscape: root.width > root.height * 1.2
                columns: isLandscape ? 1 : 3
                rows: isLandscape ? 3 : 1

                Text {
                    text: "Timer: " + gameState.timeString
                    font.pointSize: 14
                    color: "white"
                    anchors.leftMargin: parent.width / 20
                    Layout.fillWidth: true
                    Layout.row: 0
                    Layout.column: 0
                }
                Text {
                    text: "Score: " + gameState.score
                    font.pointSize: 14
                    color: "white"
                    Layout.fillWidth: true
                    Layout.row: isLandscape ? 1 : 0
                    Layout.column: isLandscape ? 0 : 1
                }
                GridLayout {
                    id: buttonContainer
                    columns: 2
                    Layout.fillWidth: true
                    Layout.row: isLandscape ? 2 : 0
                    Layout.column: isLandscape ? 0 : 2

                    Button {
                        text: "Reset"
                        Layout.fillWidth: true
                        onClicked: {
                            gameState.resetGame(drawPile, wastePile,
                                                foundation0, foundation1,
                                                foundation2, foundation3,
                                                tableau0, tableau1,
                                                tableau2, tableau3,
                                                tableau4, tableau5, tableau6)
                            gameState.resetTimer()
                        }
                    }
                    Button {
                        text: "Undo"
                        Layout.fillWidth: true
                        onClicked: {
                            gameState.undo(drawPile, wastePile,
                                           foundation0, foundation1,
                                           foundation2, foundation3,
                                           tableau0, tableau1,
                                           tableau2, tableau3,
                                           tableau4, tableau5, tableau6)
                        }
                    }
                    //Button {
                    //    text: "Hint"
                    //    Layout.fillWidth: true
                    //}
                }
            }
        }

        Rectangle {
            id: winScreen
            visible: gameState.hasWon
            anchors {
                fill: parent
            }
            color: "black"
            z: 1005
            Text {
                text: "You Win!"
                font.pointSize: 40
                color: "gold"
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height / 3
            }
            Text {
                text: "Time: " + gameState.timeString
                font.pointSize: 14
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height / 2
            }
            Text {
                text: "Base Score: " + gameState.score
                font.pointSize: 14
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height * 3 / 5
            }
            Text {
                text: "Final Score: " + gameState.finalScore
                font.pointSize: 14
                color: "white"
                anchors.horizontalCenter: parent.horizontalCenter
                y: parent.height * 7 / 10
            }
            Button {
                text: "Play Again"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.bottom: parent.bottom
                anchors.bottomMargin: parent.height * .15
                onClicked: {
                    gameState.resetGame(drawPile, wastePile,
                                        foundation0, foundation1,
                                        foundation2, foundation3,
                                        tableau0, tableau1, tableau2, tableau3,
                                        tableau4, tableau5, tableau6)
                    gameState.resetTimer()
                }
            }
            Connections {
                target: foundation0
                function onTopCardChanged() {
                    gameState.checkWin(foundation0, foundation1, foundation2,
                                       foundation3)
                    gameState.calcFoundationScore(foundation0, foundation1,
                                                  foundation2, foundation3)
                }
            }
            Connections {
                target: foundation1
                function onTopCardChanged() {
                    gameState.checkWin(foundation0, foundation1, foundation2,
                                       foundation3)
                    gameState.calcFoundationScore(foundation0, foundation1,
                                                  foundation2, foundation3)
                }
            }
            Connections {
                target: foundation2
                function onTopCardChanged() {
                    gameState.checkWin(foundation0, foundation1, foundation2,
                                       foundation3)
                    gameState.calcFoundationScore(foundation0, foundation1,
                                                  foundation2, foundation3)
                }
            }
            Connections {
                target: foundation3
                function onTopCardChanged() {
                    gameState.checkWin(foundation0, foundation1, foundation2,
                                       foundation3)
                    gameState.calcFoundationScore(foundation0, foundation1,
                                                  foundation2, foundation3)
                }
            }
        }

        Rectangle {
            id: gameBox
            width: parent.width > parent.height * 1.2 ? parent.height * 1.2 : parent.width
            height: parent.width > parent.height * 1.2 ? parent.height : parent.width * 1.2
            anchors {
                top: parent.top
                right: parent.right
            }
            color: "green"

            Rectangle {
                id: deckBorder
                anchors {
                    right: parent.right
                    top: parent.top
                    margins: parent.width / 43
                }
                width: (parent.width * 5) / 43
                height: width * 1.45
                border.color: "black"
                border.width: 1
                radius: 3
                color: "green"
                Image {
                    id: deck
                    anchors.fill: parent
                    source: drawPile.topCard ? drawPile.topCard.imagePath : ""
                    MouseArea {
                        anchors.fill: parent
                        onClicked: {
                            gameState.takeSnapshot(drawPile, wastePile,
                                                   foundation0, foundation1,
                                                   foundation2, foundation3,
                                                   tableau0, tableau1,
                                                   tableau2, tableau3,
                                                   tableau4, tableau5, tableau6)
                            wastePile.receiveDraw(drawPile)
                        }
                    }
                }
            }

            Image {
                id: waste
                x: deckBorder.x - width - (parent.width / 43)
                y: parent.width / 43
                source: wastePile.topCard ? wastePile.topCard.imagePath : ""
                width: deck.width
                height: deck.height

                MouseArea {
                    id: wasteMouseArea
                    anchors.fill: parent
                    onDoubleClicked: {
                        if (wastePile.topCard) {
                            gameState.takeSnapshot(drawPile, wastePile,
                                                   foundation0, foundation1,
                                                   foundation2, foundation3,
                                                   tableau0, tableau1,
                                                   tableau2, tableau3,
                                                   tableau4, tableau5, tableau6)
                            gameState.setDraggedCard(wastePile.playCard())
                            if (foundation0.isValid(gameState.draggedCard)) {
                                foundation0.receiveCard(gameState.draggedCard)
                            } else if (foundation1.isValid(
                                           gameState.draggedCard)) {
                                foundation1.receiveCard(gameState.draggedCard)
                            } else if (foundation2.isValid(
                                           gameState.draggedCard)) {
                                foundation2.receiveCard(gameState.draggedCard)
                            } else if (foundation3.isValid(
                                           gameState.draggedCard)) {
                                foundation3.receiveCard(gameState.draggedCard)
                            } else if (tableau0.isValid(
                                           gameState.draggedCard)) {
                                tableau0.receiveCard(gameState.draggedCard)
                            } else if (tableau1.isValid(
                                           gameState.draggedCard)) {
                                tableau1.receiveCard(gameState.draggedCard)
                            } else if (tableau2.isValid(
                                           gameState.draggedCard)) {
                                tableau2.receiveCard(gameState.draggedCard)
                            } else if (tableau3.isValid(
                                           gameState.draggedCard)) {
                                tableau3.receiveCard(gameState.draggedCard)
                            } else if (tableau4.isValid(
                                           gameState.draggedCard)) {
                                tableau4.receiveCard(gameState.draggedCard)
                            } else if (tableau5.isValid(
                                           gameState.draggedCard)) {
                                tableau5.receiveCard(gameState.draggedCard)
                            } else if (tableau6.isValid(
                                           gameState.draggedCard)) {
                                tableau6.receiveCard(gameState.draggedCard)
                            } else {
                                wastePile.receiveCard(gameState.draggedCard)
                                gameState.removeSnapshot()
                            }
                        }
                    }
                }

                DragHandler {
                    id: wasteDragHandler
                    target: draggedCardImage

                    onActiveChanged: {
                        if (active) {
                            if (wastePile.topCard) {
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)
                                gameState.setDraggedCard(
                                            wastePile.playCard(
                                                )) //Change parameter
                                gameState.setIsDragging(true)
                                draggedCardImage.visible = true

                                // Position the draggedCardImage at the mouse position
                                var globalPos = waste.mapToItem(
                                            root, centroid.position.x,
                                            centroid.position.y)
                                draggedCardImage.x = globalPos.x - draggedCardImage.width / 2
                                draggedCardImage.y = globalPos.y - draggedCardImage.height / 2
                            }
                        } else {
                            if (gameState.isDragging) {
                                if (root.isOverlapping(draggedCardImage,
                                                       foundation_0Border)) {
                                    if (foundation0.isValid(
                                                gameState.draggedCard))
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        wastePile.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_1Border)) {
                                    if (foundation1.isValid(
                                                gameState.draggedCard))
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        wastePile.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_2Border)) {
                                    if (foundation2.isValid(
                                                gameState.draggedCard))
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        wastePile.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_3Border)) {
                                    if (foundation3.isValid(
                                                gameState.draggedCard))
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        wastePile.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_0Border)) {
                                    if (tableau0.isValid(gameState.draggedCard))
                                        tableau0.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        wastePile.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_1Border)) {
                                    if (tableau1.isValid(gameState.draggedCard))
                                        tableau1.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        wastePile.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_2Border)) {
                                    if (tableau2.isValid(gameState.draggedCard))
                                        tableau2.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        wastePile.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_3Border)) {
                                    if (tableau3.isValid(gameState.draggedCard))
                                        tableau3.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        wastePile.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_4Border)) {
                                    if (tableau4.isValid(gameState.draggedCard))
                                        tableau4.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        wastePile.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_5Border)) {
                                    if (tableau5.isValid(gameState.draggedCard))
                                        tableau5.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        wastePile.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_6Border)) {
                                    if (tableau6.isValid(gameState.draggedCard))
                                        tableau6.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        wastePile.receiveCard(
                                                    gameState.draggedCard)
                                } else {
                                    wastePile.receiveCard(gameState.draggedCard)
                                    gameState.removeSnapshot()
                                }
                                gameState.setIsDragging(false)
                                draggedCardImage.visible = false
                            }
                        }
                    }

                    onCentroidChanged: {
                        if (gameState.isDragging) {
                            var globalPos = waste.mapToItem(
                                        root, centroid.position.x,
                                        centroid.position.y)
                            draggedCardImage.x = globalPos.x - draggedCardImage.width / 2
                            draggedCardImage.y = globalPos.y - draggedCardImage.height / 2
                        }
                    }
                }
            }

            // Visual element for the dragged card image
            Image {
                id: draggedCardImage
                source: gameState.draggedCard ? gameState.draggedCard.imagePath : ""
                visible: gameState.isDragging
                width: deck.width
                height: deck.height
                z: 100
            }
            // Same as above but for multiple cards (tableau piles)
            Image {
                id: draggedCardImages
                visible: gameState ? gameState.isDraggingTableau : false
                width: deck.width
                height: deck.height + (.20 * deck.height) * (gameState.multiCount - 1)
                z: 100
                Repeater {
                    model: gameState ? gameState.multiCount : 0
                    delegate: Image {
                        width: deck.width
                        height: deck.height
                        x: 0
                        y: index * deck.height * .20

                        source: gameState.cards[index] ? gameState.cards[index].imagePath : ""
                    }
                }
            }

            Rectangle {
                id: foundation_0Border
                width: deck.width
                height: deck.height
                anchors {
                    left: parent.left
                    top: parent.top
                    margins: parent.width / 43
                }

                // Set border color and width
                border.color: "black"
                border.width: 1
                radius: 3
                color: "green"

                Image {
                    id: foundation_0
                    anchors.fill: parent
                    source: foundation0.topCard ? foundation0.topCard.imagePath : ""
                }
                MouseArea {
                    id: foundation0MouseArea
                    anchors.fill: parent
                    onDoubleClicked: {

                        if (foundation0.topCard) {
                            gameState.takeSnapshot(drawPile, wastePile,
                                                   foundation0, foundation1,
                                                   foundation2, foundation3,
                                                   tableau0, tableau1,
                                                   tableau2, tableau3,
                                                   tableau4, tableau5, tableau6)
                            gameState.setDraggedCard(foundation0.playCard())
                            if (foundation1.isValid(gameState.draggedCard)) {
                                foundation1.receiveCard(gameState.draggedCard)
                            } else if (foundation2.isValid(
                                           gameState.draggedCard)) {
                                foundation2.receiveCard(gameState.draggedCard)
                            } else if (foundation3.isValid(
                                           gameState.draggedCard)) {
                                foundation3.receiveCard(gameState.draggedCard)
                            } else if (tableau0.isValid(
                                           gameState.draggedCard)) {
                                tableau0.receiveCard(gameState.draggedCard)
                            } else if (tableau1.isValid(
                                           gameState.draggedCard)) {
                                tableau1.receiveCard(gameState.draggedCard)
                            } else if (tableau2.isValid(
                                           gameState.draggedCard)) {
                                tableau2.receiveCard(gameState.draggedCard)
                            } else if (tableau3.isValid(
                                           gameState.draggedCard)) {
                                tableau3.receiveCard(gameState.draggedCard)
                            } else if (tableau4.isValid(
                                           gameState.draggedCard)) {
                                tableau4.receiveCard(gameState.draggedCard)
                            } else if (tableau5.isValid(
                                           gameState.draggedCard)) {
                                tableau5.receiveCard(gameState.draggedCard)
                            } else if (tableau6.isValid(
                                           gameState.draggedCard)) {
                                tableau6.receiveCard(gameState.draggedCard)
                            } else {
                                gameState.removeSnapshot()
                                foundation0.receiveCard(gameState.draggedCard)
                            }
                        }
                    }
                }
                DragHandler {
                    id: foundation0DragHandler
                    target: draggedCardImage

                    onActiveChanged: {
                        if (active) {
                            if (foundation0.topCard) {
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)
                                gameState.setDraggedCard(
                                            foundation0.playCard(
                                                )) //Change parameter
                                gameState.setIsDragging(true)
                                draggedCardImage.visible = true

                                // Position the draggedCardImage at the mouse position
                                var globalPos = waste.mapToItem(
                                            root, centroid.position.x,
                                            centroid.position.y)
                                draggedCardImage.x = globalPos.x - draggedCardImage.width / 2
                                draggedCardImage.y = globalPos.y - draggedCardImage.height / 2
                            }
                        } else {
                            if (gameState.isDragging) {
                                if (root.isOverlapping(draggedCardImage,
                                                       foundation_1Border)) {
                                    if (foundation1.isValid(
                                                gameState.draggedCard))
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_2Border)) {
                                    if (foundation2.isValid(
                                                gameState.draggedCard))
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_3Border)) {
                                    if (foundation3.isValid(
                                                gameState.draggedCard))
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_0Border)) {
                                    if (tableau0.isValid(gameState.draggedCard))
                                        tableau0.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_1Border)) {
                                    if (tableau1.isValid(gameState.draggedCard))
                                        tableau1.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_2Border)) {
                                    if (tableau2.isValid(gameState.draggedCard))
                                        tableau2.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_3Border)) {
                                    if (tableau3.isValid(gameState.draggedCard))
                                        tableau3.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_4Border)) {
                                    if (tableau4.isValid(gameState.draggedCard))
                                        tableau4.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_5Border)) {
                                    if (tableau5.isValid(gameState.draggedCard))
                                        tableau5.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_6Border)) {
                                    if (tableau6.isValid(gameState.draggedCard))
                                        tableau6.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                } else {
                                    foundation0.receiveCard(
                                                gameState.draggedCard)
                                    gameState.removeSnapshot()
                                }
                                gameState.setIsDragging(false)
                                draggedCardImage.visible = false
                            }
                        }
                    }

                    onCentroidChanged: {
                        if (gameState.isDragging) {
                            var globalPos = waste.mapToItem(
                                        root, centroid.position.x,
                                        centroid.position.y)
                            draggedCardImage.x = globalPos.x - draggedCardImage.width / 2
                            draggedCardImage.y = globalPos.y - draggedCardImage.height / 2
                        }
                    }
                }
            }
            Rectangle {
                id: foundation_1Border
                width: deck.width
                height: deck.height
                anchors {
                    left: foundation_0Border.right
                    top: parent.top
                    margins: parent.width / 43
                }

                // Set border color and width
                border.color: "black"
                border.width: 1
                radius: 3
                color: "green"

                Image {
                    id: foundation_1
                    anchors.fill: parent
                    source: foundation1.topCard ? foundation1.topCard.imagePath : ""
                }
                MouseArea {
                    id: foundation1MouseArea
                    anchors.fill: parent
                    onDoubleClicked: {
                        if (foundation1.topCard) {
                            gameState.takeSnapshot(drawPile, wastePile,
                                                   foundation0, foundation1,
                                                   foundation2, foundation3,
                                                   tableau0, tableau1,
                                                   tableau2, tableau3,
                                                   tableau4, tableau5, tableau6)
                            gameState.setDraggedCard(foundation1.playCard())
                            if (foundation0.isValid(gameState.draggedCard)) {
                                foundation0.receiveCard(gameState.draggedCard)
                            } else if (foundation2.isValid(
                                           gameState.draggedCard)) {
                                foundation2.receiveCard(gameState.draggedCard)
                            } else if (foundation3.isValid(
                                           gameState.draggedCard)) {
                                foundation3.receiveCard(gameState.draggedCard)
                            } else if (tableau0.isValid(
                                           gameState.draggedCard)) {
                                tableau0.receiveCard(gameState.draggedCard)
                            } else if (tableau1.isValid(
                                           gameState.draggedCard)) {
                                tableau1.receiveCard(gameState.draggedCard)
                            } else if (tableau2.isValid(
                                           gameState.draggedCard)) {
                                tableau2.receiveCard(gameState.draggedCard)
                            } else if (tableau3.isValid(
                                           gameState.draggedCard)) {
                                tableau3.receiveCard(gameState.draggedCard)
                            } else if (tableau4.isValid(
                                           gameState.draggedCard)) {
                                tableau4.receiveCard(gameState.draggedCard)
                            } else if (tableau5.isValid(
                                           gameState.draggedCard)) {
                                tableau5.receiveCard(gameState.draggedCard)
                            } else if (tableau6.isValid(
                                           gameState.draggedCard)) {
                                tableau6.receiveCard(gameState.draggedCard)
                            } else {
                                gameState.removeSnapshot()
                                foundation1.receiveCard(gameState.draggedCard)
                            }
                        }
                    }
                }
                DragHandler {
                    id: foundation1DragHandler
                    target: draggedCardImage

                    onActiveChanged: {
                        if (active) {
                            if (foundation1.topCard) {
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)
                                gameState.setDraggedCard(
                                            foundation1.playCard(
                                                )) //Change parameter
                                gameState.setIsDragging(true)
                                draggedCardImage.visible = true

                                // Position the draggedCardImage at the mouse position
                                var globalPos = waste.mapToItem(
                                            root, centroid.position.x,
                                            centroid.position.y)
                                draggedCardImage.x = globalPos.x - draggedCardImage.width / 2
                                draggedCardImage.y = globalPos.y - draggedCardImage.height / 2
                            }
                        } else {
                            if (gameState.isDragging) {
                                if (root.isOverlapping(draggedCardImage,
                                                       foundation_0Border)) {
                                    if (foundation0.isValid(
                                                gameState.draggedCard))
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_1Border)) {
                                    if (foundation1.isValid(
                                                gameState.draggedCard))
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_2Border)) {
                                    if (foundation2.isValid(
                                                gameState.draggedCard))
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_3Border)) {
                                    if (foundation3.isValid(
                                                gameState.draggedCard))
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_0Border)) {
                                    if (tableau0.isValid(gameState.draggedCard))
                                        tableau0.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_1Border)) {
                                    if (tableau1.isValid(gameState.draggedCard))
                                        tableau1.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_2Border)) {
                                    if (tableau2.isValid(gameState.draggedCard))
                                        tableau2.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_3Border)) {
                                    if (tableau3.isValid(gameState.draggedCard))
                                        tableau3.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_4Border)) {
                                    if (tableau4.isValid(gameState.draggedCard))
                                        tableau4.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_5Border)) {
                                    if (tableau5.isValid(gameState.draggedCard))
                                        tableau5.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_6Border)) {
                                    if (tableau6.isValid(gameState.draggedCard))
                                        tableau6.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                } else {
                                    gameState.removeSnapshot()
                                    foundation1.receiveCard(
                                                gameState.draggedCard)
                                }
                                gameState.setIsDragging(false)
                                draggedCardImage.visible = false
                            }
                        }
                    }

                    onCentroidChanged: {
                        if (gameState.isDragging) {
                            var globalPos = waste.mapToItem(
                                        root, centroid.position.x,
                                        centroid.position.y)
                            draggedCardImage.x = globalPos.x - draggedCardImage.width / 2
                            draggedCardImage.y = globalPos.y - draggedCardImage.height / 2
                        }
                    }
                }
            }
            Rectangle {
                id: foundation_2Border
                width: deck.width
                height: deck.height
                anchors {
                    left: foundation_1Border.right
                    top: parent.top
                    margins: parent.width / 43
                }

                // Set border color and width
                border.color: "black"
                border.width: 1
                radius: 3
                color: "green"

                Image {
                    id: foundation_2
                    anchors.fill: parent
                    source: foundation2.topCard ? foundation2.topCard.imagePath : ""
                }
                MouseArea {
                    id: foundation2MouseArea
                    anchors.fill: parent
                    onDoubleClicked: {

                        if (foundation2.topCard) {
                            gameState.takeSnapshot(drawPile, wastePile,
                                                   foundation0, foundation1,
                                                   foundation2, foundation3,
                                                   tableau0, tableau1,
                                                   tableau2, tableau3,
                                                   tableau4, tableau5, tableau6)
                            gameState.setDraggedCard(foundation2.playCard())
                            if (foundation0.isValid(gameState.draggedCard)) {
                                foundation0.receiveCard(gameState.draggedCard)
                            } else if (foundation1.isValid(
                                           gameState.draggedCard)) {
                                foundation1.receiveCard(gameState.draggedCard)
                            } else if (foundation3.isValid(
                                           gameState.draggedCard)) {
                                foundation3.receiveCard(gameState.draggedCard)
                            } else if (tableau0.isValid(
                                           gameState.draggedCard)) {
                                tableau0.receiveCard(gameState.draggedCard)
                            } else if (tableau1.isValid(
                                           gameState.draggedCard)) {
                                tableau1.receiveCard(gameState.draggedCard)
                            } else if (tableau2.isValid(
                                           gameState.draggedCard)) {
                                tableau2.receiveCard(gameState.draggedCard)
                            } else if (tableau3.isValid(
                                           gameState.draggedCard)) {
                                tableau3.receiveCard(gameState.draggedCard)
                            } else if (tableau4.isValid(
                                           gameState.draggedCard)) {
                                tableau4.receiveCard(gameState.draggedCard)
                            } else if (tableau5.isValid(
                                           gameState.draggedCard)) {
                                tableau5.receiveCard(gameState.draggedCard)
                            } else if (tableau6.isValid(
                                           gameState.draggedCard)) {
                                tableau6.receiveCard(gameState.draggedCard)
                            } else {
                                gameState.removeSnapshot()
                                foundation2.receiveCard(gameState.draggedCard)
                            }
                        }
                    }
                }
                DragHandler {
                    id: foundation2DragHandler
                    target: draggedCardImage

                    onActiveChanged: {
                        if (active) {
                            if (foundation2.topCard) {
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)
                                gameState.setDraggedCard(
                                            foundation2.playCard(
                                                )) //Change parameter
                                gameState.setIsDragging(true)
                                draggedCardImage.visible = true

                                // Position the draggedCardImage at the mouse position
                                var globalPos = waste.mapToItem(
                                            root, centroid.position.x,
                                            centroid.position.y)
                                draggedCardImage.x = globalPos.x - draggedCardImage.width / 2
                                draggedCardImage.y = globalPos.y - draggedCardImage.height / 2
                            }
                        } else {
                            if (gameState.isDragging) {
                                if (root.isOverlapping(draggedCardImage,
                                                       foundation_0Border)) {
                                    if (foundation0.isValid(
                                                gameState.draggedCard))
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_1Border)) {
                                    if (foundation1.isValid(
                                                gameState.draggedCard))
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_2Border)) {
                                    if (foundation2.isValid(
                                                gameState.draggedCard))
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_3Border)) {
                                    if (foundation3.isValid(
                                                gameState.draggedCard))
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_0Border)) {
                                    if (tableau0.isValid(gameState.draggedCard))
                                        tableau0.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_1Border)) {
                                    if (tableau1.isValid(gameState.draggedCard))
                                        tableau1.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_2Border)) {
                                    if (tableau2.isValid(gameState.draggedCard))
                                        tableau2.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_3Border)) {
                                    if (tableau3.isValid(gameState.draggedCard))
                                        tableau3.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_4Border)) {
                                    if (tableau4.isValid(gameState.draggedCard))
                                        tableau4.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_5Border)) {
                                    if (tableau5.isValid(gameState.draggedCard))
                                        tableau5.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_6Border)) {
                                    if (tableau6.isValid(gameState.draggedCard))
                                        tableau6.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                } else {
                                    gameState.removeSnapshot()
                                    foundation2.receiveCard(
                                                gameState.draggedCard)
                                }
                                gameState.setIsDragging(false)
                                draggedCardImage.visible = false
                            }
                        }
                    }

                    onCentroidChanged: {
                        if (gameState.isDragging) {
                            var globalPos = waste.mapToItem(
                                        root, centroid.position.x,
                                        centroid.position.y)
                            draggedCardImage.x = globalPos.x - draggedCardImage.width / 2
                            draggedCardImage.y = globalPos.y - draggedCardImage.height / 2
                        }
                    }
                }
            }
            Rectangle {
                id: foundation_3Border
                width: deck.width
                height: deck.height
                anchors {
                    left: foundation_2Border.right
                    top: parent.top
                    margins: parent.width / 43
                }

                // Set border color and width
                border.color: "black"
                border.width: 1
                radius: 3
                color: "green"

                Image {
                    id: foundation_3
                    anchors.fill: parent
                    source: foundation3.topCard ? foundation3.topCard.imagePath : ""
                }
                MouseArea {
                    id: foundation3MouseArea
                    anchors.fill: parent
                    onDoubleClicked: {

                        if (foundation3.topCard) {
                            gameState.takeSnapshot(drawPile, wastePile,
                                                   foundation0, foundation1,
                                                   foundation2, foundation3,
                                                   tableau0, tableau1,
                                                   tableau2, tableau3,
                                                   tableau4, tableau5, tableau6)
                            gameState.setDraggedCard(foundation3.playCard())
                            if (foundation0.isValid(gameState.draggedCard)) {
                                foundation0.receiveCard(gameState.draggedCard)
                            } else if (foundation1.isValid(
                                           gameState.draggedCard)) {
                                foundation1.receiveCard(gameState.draggedCard)
                            } else if (foundation2.isValid(
                                           gameState.draggedCard)) {
                                foundation2.receiveCard(gameState.draggedCard)
                            } else if (tableau0.isValid(
                                           gameState.draggedCard)) {
                                tableau0.receiveCard(gameState.draggedCard)
                            } else if (tableau1.isValid(
                                           gameState.draggedCard)) {
                                tableau1.receiveCard(gameState.draggedCard)
                            } else if (tableau2.isValid(
                                           gameState.draggedCard)) {
                                tableau2.receiveCard(gameState.draggedCard)
                            } else if (tableau3.isValid(
                                           gameState.draggedCard)) {
                                tableau3.receiveCard(gameState.draggedCard)
                            } else if (tableau4.isValid(
                                           gameState.draggedCard)) {
                                tableau4.receiveCard(gameState.draggedCard)
                            } else if (tableau5.isValid(
                                           gameState.draggedCard)) {
                                tableau5.receiveCard(gameState.draggedCard)
                            } else if (tableau6.isValid(
                                           gameState.draggedCard)) {
                                tableau6.receiveCard(gameState.draggedCard)
                            } else {
                                foundation3.receiveCard(gameState.draggedCard)
                                gameState.removeSnapshot()
                            }
                        }
                    }
                }
                DragHandler {
                    id: foundation3DragHandler
                    target: draggedCardImage

                    onActiveChanged: {
                        if (active) {
                            if (foundation3.topCard) {
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)
                                gameState.setDraggedCard(
                                            foundation3.playCard(
                                                )) //Change parameter
                                gameState.setIsDragging(true)
                                draggedCardImage.visible = true

                                // Position the draggedCardImage at the mouse position
                                var globalPos = waste.mapToItem(
                                            root, centroid.position.x,
                                            centroid.position.y)
                                draggedCardImage.x = globalPos.x - draggedCardImage.width / 2
                                draggedCardImage.y = globalPos.y - draggedCardImage.height / 2
                            }
                        } else {
                            if (gameState.isDragging) {
                                if (root.isOverlapping(draggedCardImage,
                                                       foundation_0Border)) {
                                    if (foundation0.isValid(
                                                gameState.draggedCard))
                                        foundation0.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_1Border)) {
                                    if (foundation1.isValid(
                                                gameState.draggedCard))
                                        foundation1.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_2Border)) {
                                    if (foundation2.isValid(
                                                gameState.draggedCard))
                                        foundation2.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               foundation_3Border)) {
                                    if (foundation3.isValid(
                                                gameState.draggedCard))
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_0Border)) {
                                    if (tableau0.isValid(gameState.draggedCard))
                                        tableau0.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_1Border)) {
                                    if (tableau1.isValid(gameState.draggedCard))
                                        tableau1.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_2Border)) {
                                    if (tableau2.isValid(gameState.draggedCard))
                                        tableau2.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_3Border)) {
                                    if (tableau3.isValid(gameState.draggedCard))
                                        tableau3.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_4Border)) {
                                    if (tableau4.isValid(gameState.draggedCard))
                                        tableau4.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_5Border)) {
                                    if (tableau5.isValid(gameState.draggedCard))
                                        tableau5.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                } else if (root.isOverlapping(
                                               draggedCardImage,
                                               tableau_6Border)) {
                                    if (tableau6.isValid(gameState.draggedCard))
                                        tableau6.receiveCard(
                                                    gameState.draggedCard)
                                    else
                                        foundation3.receiveCard(
                                                    gameState.draggedCard)
                                } else {
                                    foundation3.receiveCard(
                                                gameState.draggedCard)
                                    gameState.removeSnapshot()
                                }
                                gameState.setIsDragging(false)
                                draggedCardImage.visible = false
                            }
                        }
                    }

                    onCentroidChanged: {
                        if (gameState.isDragging) {
                            var globalPos = waste.mapToItem(
                                        root, centroid.position.x,
                                        centroid.position.y)
                            draggedCardImage.x = globalPos.x - draggedCardImage.width / 2
                            draggedCardImage.y = globalPos.y - draggedCardImage.height / 2
                        }
                    }
                }
            }

            Rectangle {
                id: tableau_0Border
                width: deck.width
                height: deck.height + (tableau0.count > 1 ? (.20 * deck.height)
                                                            * (tableau0.count - 1) : 0)
                x: foundation_0Border.x
                anchors {
                    top: foundation_0Border.bottom
                    margins: parent.width / 43
                }
                // Set border color and width
                color: "green"
                Rectangle {
                    width: parent.width
                    height: deck.height
                    border.color: "black"
                    border.width: 1
                    radius: 3
                    color: "green"
                }
                Repeater {
                    model: tableau0 ? tableau0.count : 0
                    delegate: Image {
                        id: tableau0CardImage
                        width: deck.width
                        height: deck.height
                        x: 0
                        y: index * deck.height * 0.20
                        source: tableau0.cards[index].imagePath

                        // Property to determine if this card is being dragged
                        property bool isBeingDragged: gameState.isDraggingTableau
                                                      && index >= gameState.dragStart
                                                      && gameState.dragSourceTableau === tableau0

                        // Adjust opacity based on whether the card is being dragged
                        opacity: isBeingDragged ? 0 : 1

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                draggedCardImages.x = tableau_0Border.x
                                draggedCardImages.y = this.mapToItem(null, 0,
                                                                     0).y
                            }
                            onDoubleClicked: {
                                gameState.receiveCards(
                                            tableau0.copyCards(index))
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)
                                if (foundation0.isValidTableau(
                                            gameState.cards)) {
                                    foundation0.receiveTableau(gameState.cards)
                                    tableau0.playCards(index)
                                } else if (foundation1.isValidTableau(
                                               gameState.cards)) {
                                    foundation1.receiveTableau(gameState.cards)
                                    tableau0.playCards(index)
                                } else if (foundation2.isValidTableau(
                                               gameState.cards)) {
                                    foundation2.receiveTableau(gameState.cards)
                                    tableau0.playCards(index)
                                } else if (foundation3.isValidTableau(
                                               gameState.cards)) {
                                    foundation3.receiveTableau(gameState.cards)
                                    tableau0.playCards(index)
                                } else if (tableau1.isValidTableau(
                                               gameState.cards)) {
                                    tableau1.receiveCards(gameState.cards)
                                    tableau0.playCards(index)
                                } else if (tableau2.isValidTableau(
                                               gameState.cards)) {
                                    tableau2.receiveCards(gameState.cards)
                                    tableau0.playCards(index)
                                } else if (tableau3.isValidTableau(
                                               gameState.cards)) {
                                    tableau3.receiveCards(gameState.cards)
                                    tableau0.playCards(index)
                                } else if (tableau4.isValidTableau(
                                               gameState.cards)) {
                                    tableau4.receiveCards(gameState.cards)
                                    tableau0.playCards(index)
                                } else if (tableau5.isValidTableau(
                                               gameState.cards)) {
                                    tableau5.receiveCards(gameState.cards)
                                    tableau0.playCards(index)
                                } else if (tableau6.isValidTableau(
                                               gameState.cards)) {
                                    tableau6.receiveCards(gameState.cards)
                                    tableau0.playCards(index)
                                } else
                                    gameState.removeSnapshot()
                            }
                        }

                        DragHandler {
                            target: draggedCardImages
                            enabled: tableau0.cards[index].isShowing
                            snapMode: DragHandler.NoSnap
                            onActiveChanged: {
                                if (active) {
                                    gameState.takeSnapshot(
                                                drawPile, wastePile,
                                                foundation0, foundation1,
                                                foundation2, foundation3,
                                                tableau0, tableau1,
                                                tableau2, tableau3,
                                                tableau4, tableau5, tableau6)
                                    gameState.receiveCards(
                                                tableau0.copyCards(index))
                                    gameState.dragStart = index
                                    gameState.dragSourceTableau = tableau0
                                    // Defer the model modification
                                    gameState.setIsDraggingTableau(true)
                                    draggedCardImages.visible = true
                                } else {
                                    // Handle dropping the card(s)
                                    if (root.isOverlapping(
                                                draggedCardImages,
                                                foundation_0Border)) {
                                        if (foundation0.isValidTableau(
                                                    gameState.cards)) {
                                            foundation0.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau0.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_1Border)) {
                                        if (foundation1.isValidTableau(
                                                    gameState.cards)) {
                                            foundation1.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau0.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_2Border)) {
                                        if (foundation2.isValidTableau(
                                                    gameState.cards)) {
                                            foundation2.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau0.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_3Border)) {
                                        if (foundation3.isValidTableau(
                                                    gameState.cards)) {
                                            foundation3.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau0.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_0Border)) {
                                        if (tableau0.isValidTableau(
                                                    gameState.cards)) {
                                            tableau0.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau0.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_1Border)) {
                                        if (tableau1.isValidTableau(
                                                    gameState.cards)) {
                                            tableau1.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau0.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_2Border)) {
                                        if (tableau2.isValidTableau(
                                                    gameState.cards)) {
                                            tableau2.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau0.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_3Border)) {
                                        if (tableau3.isValidTableau(
                                                    gameState.cards)) {
                                            tableau3.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau0.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_4Border)) {
                                        if (tableau4.isValidTableau(
                                                    gameState.cards)) {
                                            tableau4.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau0.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_5Border)) {
                                        if (tableau5.isValidTableau(
                                                    gameState.cards)) {
                                            tableau5.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau0.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_6Border)) {
                                        if (tableau6.isValidTableau(
                                                    gameState.cards)) {
                                            tableau6.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau0.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else {
                                        gameState.removeSnapshot()
                                        gameState.setIsDraggingTableau(false)
                                        draggedCardImages.visible = false
                                        gameState.dragStart = -1
                                        gameState.dragSourceTableau = null
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: tableau_1Border
                width: deck.width
                height: deck.height + (tableau1.count > 1 ? (.20 * deck.height)
                                                            * (tableau1.count - 1) : 0)
                x: (parent.width * 7) / 43 //Add 6 for to the 7 for each following pile
                y: tableau_0Border.y
                anchors {
                    margins: parent.width / 43
                }
                // Set border color and width
                color: "green"
                Rectangle {
                    width: parent.width
                    height: deck.height
                    border.color: "black"
                    border.width: 1
                    radius: 3
                    color: "green"
                }
                Repeater {
                    model: tableau1 ? tableau1.count : 0
                    delegate: Image {
                        id: tableau1CardImage
                        width: deck.width
                        height: deck.height
                        x: 0
                        y: index * deck.height * 0.20
                        source: tableau1.cards[index].imagePath

                        // Property to determine if this card is being dragged
                        property bool isBeingDragged: gameState.isDraggingTableau
                                                      && index >= gameState.dragStart
                                                      && gameState.dragSourceTableau === tableau1

                        // Adjust opacity based on whether the card is being dragged
                        opacity: isBeingDragged ? 0 : 1

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                draggedCardImages.x = tableau_1Border.x
                                draggedCardImages.y = this.mapToItem(null, 0,
                                                                     0).y
                            }
                            onDoubleClicked: {
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)
                                gameState.receiveCards(
                                            tableau1.copyCards(index))

                                if (foundation0.isValidTableau(
                                            gameState.cards)) {
                                    foundation0.receiveTableau(gameState.cards)
                                    tableau1.playCards(index)
                                } else if (foundation1.isValidTableau(
                                               gameState.cards)) {
                                    foundation1.receiveTableau(gameState.cards)
                                    tableau1.playCards(index)
                                } else if (foundation2.isValidTableau(
                                               gameState.cards)) {
                                    foundation2.receiveTableau(gameState.cards)
                                    tableau1.playCards(index)
                                } else if (foundation3.isValidTableau(
                                               gameState.cards)) {
                                    foundation3.receiveTableau(gameState.cards)
                                    tableau1.playCards(index)
                                } else if (tableau0.isValidTableau(
                                               gameState.cards)) {
                                    tableau0.receiveCards(gameState.cards)
                                    tableau1.playCards(index)
                                } else if (tableau2.isValidTableau(
                                               gameState.cards)) {
                                    tableau2.receiveCards(gameState.cards)
                                    tableau1.playCards(index)
                                } else if (tableau3.isValidTableau(
                                               gameState.cards)) {
                                    tableau3.receiveCards(gameState.cards)
                                    tableau1.playCards(index)
                                } else if (tableau4.isValidTableau(
                                               gameState.cards)) {
                                    tableau4.receiveCards(gameState.cards)
                                    tableau1.playCards(index)
                                } else if (tableau5.isValidTableau(
                                               gameState.cards)) {
                                    tableau5.receiveCards(gameState.cards)
                                    tableau1.playCards(index)
                                } else if (tableau6.isValidTableau(
                                               gameState.cards)) {
                                    tableau6.receiveCards(gameState.cards)
                                    tableau1.playCards(index)
                                } else
                                    gameState.removeSnapshot()
                            }
                        }

                        DragHandler {
                            target: draggedCardImages
                            enabled: tableau1.cards[index].isShowing
                            snapMode: DragHandler.NoSnap
                            onActiveChanged: {
                                if (active) {
                                    // Start dragging the card(s)
                                    gameState.takeSnapshot(
                                                drawPile, wastePile,
                                                foundation0, foundation1,
                                                foundation2, foundation3,
                                                tableau0, tableau1,
                                                tableau2, tableau3,
                                                tableau4, tableau5, tableau6)
                                    gameState.receiveCards(
                                                tableau1.copyCards(index))
                                    gameState.dragStart = index
                                    gameState.dragSourceTableau = tableau1
                                    // Defer the model modification
                                    gameState.setIsDraggingTableau(true)
                                    draggedCardImages.visible = true
                                } else {
                                    // Handle dropping the card(s)
                                    if (root.isOverlapping(
                                                draggedCardImages,
                                                foundation_0Border)) {
                                        if (foundation0.isValidTableau(
                                                    gameState.cards)) {
                                            foundation0.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau1.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_1Border)) {
                                        if (foundation1.isValidTableau(
                                                    gameState.cards)) {
                                            foundation1.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau1.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_2Border)) {
                                        if (foundation2.isValidTableau(
                                                    gameState.cards)) {
                                            foundation2.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau1.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_3Border)) {
                                        if (foundation3.isValidTableau(
                                                    gameState.cards)) {
                                            foundation3.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau1.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_0Border)) {
                                        if (tableau0.isValidTableau(
                                                    gameState.cards)) {
                                            tableau0.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau1.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_1Border)) {
                                        if (tableau1.isValidTableau(
                                                    gameState.cards)) {
                                            tableau1.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau1.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_2Border)) {
                                        if (tableau2.isValidTableau(
                                                    gameState.cards)) {
                                            tableau2.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau1.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_3Border)) {
                                        if (tableau3.isValidTableau(
                                                    gameState.cards)) {
                                            tableau3.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau1.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_4Border)) {
                                        if (tableau4.isValidTableau(
                                                    gameState.cards)) {
                                            tableau4.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau1.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_5Border)) {
                                        if (tableau5.isValidTableau(
                                                    gameState.cards)) {
                                            tableau5.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau1.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_6Border)) {
                                        if (tableau6.isValidTableau(
                                                    gameState.cards)) {
                                            tableau6.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau1.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else {
                                        gameState.removeSnapshot()
                                        gameState.setIsDraggingTableau(false)
                                        draggedCardImages.visible = false
                                        gameState.dragStart = -1
                                        gameState.dragSourceTableau = null
                                    }
                                }
                                //onCentroidChanged: {
                                //    if (gameState.isDraggingTableau) {
                                //        var globalPos = tableau1CardImage.mapToItem(
                                //                    root, centroid.position.x,
                                //                    centroid.position.y)
                                //        draggedCardImages.x = globalPos.x
                                //                - draggedCardImages.width / 2
                                //        draggedCardImages.y = globalPos.y
                                //                - draggedCardImages.height / 2
                                //    }
                                //}
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: tableau_2Border
                width: deck.width
                height: deck.height + (tableau2.count > 1 ? (.20 * deck.height)
                                                            * (tableau2.count - 1) : 0)
                y: tableau_0Border.y
                x: (parent.width * 13) / 43 //Add 6 for to the 13 for each following pile
                anchors {
                    margins: parent.width / 43
                }
                color: "green"
                Rectangle {
                    width: parent.width
                    height: deck.height
                    border.color: "black"
                    border.width: 1
                    radius: 3
                    color: "green"
                }
                Repeater {
                    model: tableau2 ? tableau2.count : 0
                    delegate: Image {
                        id: tableau2CardImage
                        width: deck.width
                        height: deck.height
                        x: 0
                        y: index * deck.height * 0.20
                        source: tableau2.cards[index].imagePath

                        // Property to determine if this card is being dragged
                        property bool isBeingDragged: gameState.isDraggingTableau
                                                      && index >= gameState.dragStart
                                                      && gameState.dragSourceTableau === tableau2

                        // Adjust opacity based on whether the card is being dragged
                        opacity: isBeingDragged ? 0 : 1

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                draggedCardImages.x = tableau_2Border.x
                                draggedCardImages.y = this.mapToItem(null, 0,
                                                                     0).y
                            }
                            onDoubleClicked: {
                                gameState.receiveCards(
                                            tableau2.copyCards(index))
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)

                                if (foundation0.isValidTableau(
                                            gameState.cards)) {
                                    foundation0.receiveTableau(gameState.cards)
                                    tableau2.playCards(index)
                                } else if (foundation1.isValidTableau(
                                               gameState.cards)) {
                                    foundation1.receiveTableau(gameState.cards)
                                    tableau2.playCards(index)
                                } else if (foundation2.isValidTableau(
                                               gameState.cards)) {
                                    foundation2.receiveTableau(gameState.cards)
                                    tableau2.playCards(index)
                                } else if (foundation3.isValidTableau(
                                               gameState.cards)) {
                                    foundation3.receiveTableau(gameState.cards)
                                    tableau2.playCards(index)
                                } else if (tableau0.isValidTableau(
                                               gameState.cards)) {
                                    tableau0.receiveCards(gameState.cards)
                                    tableau2.playCards(index)
                                } else if (tableau1.isValidTableau(
                                               gameState.cards)) {
                                    tableau1.receiveCards(gameState.cards)
                                    tableau2.playCards(index)
                                } else if (tableau3.isValidTableau(
                                               gameState.cards)) {
                                    tableau3.receiveCards(gameState.cards)
                                    tableau2.playCards(index)
                                } else if (tableau4.isValidTableau(
                                               gameState.cards)) {
                                    tableau4.receiveCards(gameState.cards)
                                    tableau2.playCards(index)
                                } else if (tableau5.isValidTableau(
                                               gameState.cards)) {
                                    tableau5.receiveCards(gameState.cards)
                                    tableau2.playCards(index)
                                } else if (tableau6.isValidTableau(
                                               gameState.cards)) {
                                    tableau6.receiveCards(gameState.cards)
                                    tableau2.playCards(index)
                                } else
                                    gameState.removeSnapshot()
                            }
                        }

                        DragHandler {
                            id: dragHandler
                            target: draggedCardImages
                            enabled: tableau2.cards[index].isShowing
                            snapMode: DragHandler.NoSnap
                            onActiveChanged: {
                                if (active) {
                                    // Start dragging the card(s)
                                    gameState.receiveCards(
                                                tableau2.copyCards(index))
                                    gameState.takeSnapshot(
                                                drawPile, wastePile,
                                                foundation0, foundation1,
                                                foundation2, foundation3,
                                                tableau0, tableau1,
                                                tableau2, tableau3,
                                                tableau4, tableau5, tableau6)
                                    gameState.dragStart = index
                                    gameState.dragSourceTableau = tableau2
                                    // Defer the model modification
                                    gameState.setIsDraggingTableau(true)
                                    draggedCardImages.visible = true
                                } else {
                                    // Handle dropping the card(s)
                                    if (root.isOverlapping(
                                                draggedCardImages,
                                                foundation_0Border)) {
                                        if (foundation0.isValidTableau(
                                                    gameState.cards)) {
                                            foundation0.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau2.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_1Border)) {
                                        if (foundation1.isValidTableau(
                                                    gameState.cards)) {
                                            foundation1.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau2.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_2Border)) {
                                        if (foundation2.isValidTableau(
                                                    gameState.cards)) {
                                            foundation2.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau2.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_3Border)) {
                                        if (foundation3.isValidTableau(
                                                    gameState.cards)) {
                                            foundation3.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau2.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_0Border)) {
                                        if (tableau0.isValidTableau(
                                                    gameState.cards)) {
                                            tableau0.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau2.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_1Border)) {
                                        if (tableau1.isValidTableau(
                                                    gameState.cards)) {
                                            tableau1.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau2.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_2Border)) {
                                        if (tableau2.isValidTableau(
                                                    gameState.cards)) {
                                            tableau2.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau2.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_3Border)) {
                                        if (tableau3.isValidTableau(
                                                    gameState.cards)) {
                                            tableau3.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau2.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_4Border)) {
                                        if (tableau4.isValidTableau(
                                                    gameState.cards)) {
                                            tableau4.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau2.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_5Border)) {
                                        if (tableau5.isValidTableau(
                                                    gameState.cards)) {
                                            tableau5.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau2.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_6Border)) {
                                        if (tableau6.isValidTableau(
                                                    gameState.cards)) {
                                            tableau6.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau2.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else {
                                        gameState.removeSnapshot()
                                        gameState.setIsDraggingTableau(false)
                                        draggedCardImages.visible = false
                                        gameState.dragStart = -1
                                        gameState.dragSourceTableau = null
                                    }
                                }
                                //onCentroidChanged: {
                                //    if (gameState.isDraggingTableau) {
                                //        var globalPos = tableau2CardImage.mapToItem(
                                //                    root, centroid.position.x,
                                //                    centroid.position.y)
                                //        draggedCardImages.x = globalPos.x
                                //                - draggedCardImages.width / 2
                                //        draggedCardImages.y = globalPos.y
                                //                - draggedCardImages.height / 2
                                //    }
                                //}
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: tableau_3Border
                width: deck.width
                height: deck.height + (tableau3.count > 1 ? (.20 * deck.height)
                                                            * (tableau3.count - 1) : 0)
                y: tableau_0Border.y
                anchors {
                    left: tableau_2Border.right
                    margins: parent.width / 43
                }
                color: "green"
                Rectangle {
                    width: parent.width
                    height: deck.height
                    border.color: "black"
                    border.width: 1
                    radius: 3
                    color: "green"
                }
                Repeater {
                    model: tableau3 ? tableau3.count : 0
                    delegate: Image {
                        id: tableau3CardImage
                        width: deck.width
                        height: deck.height
                        x: 0
                        y: index * deck.height * 0.20
                        source: tableau3.cards[index].imagePath

                        // Property to determine if this card is being dragged
                        property bool isBeingDragged: gameState.isDraggingTableau
                                                      && index >= gameState.dragStart
                                                      && gameState.dragSourceTableau === tableau3

                        // Adjust opacity based on whether the card is being dragged
                        opacity: isBeingDragged ? 0 : 1

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                draggedCardImages.x = tableau_3Border.x
                                draggedCardImages.y = this.mapToItem(null, 0,
                                                                     0).y
                            }
                            onDoubleClicked: {
                                gameState.receiveCards(
                                            tableau3.copyCards(index))
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)

                                if (foundation0.isValidTableau(
                                            gameState.cards)) {
                                    foundation0.receiveTableau(gameState.cards)
                                    tableau3.playCards(index)
                                } else if (foundation1.isValidTableau(
                                               gameState.cards)) {
                                    foundation1.receiveTableau(gameState.cards)
                                    tableau3.playCards(index)
                                } else if (foundation2.isValidTableau(
                                               gameState.cards)) {
                                    foundation2.receiveTableau(gameState.cards)
                                    tableau3.playCards(index)
                                } else if (foundation3.isValidTableau(
                                               gameState.cards)) {
                                    foundation3.receiveTableau(gameState.cards)
                                    tableau3.playCards(index)
                                } else if (tableau0.isValidTableau(
                                               gameState.cards)) {
                                    tableau0.receiveCards(gameState.cards)
                                    tableau3.playCards(index)
                                } else if (tableau1.isValidTableau(
                                               gameState.cards)) {
                                    tableau1.receiveCards(gameState.cards)
                                    tableau3.playCards(index)
                                } else if (tableau2.isValidTableau(
                                               gameState.cards)) {
                                    tableau2.receiveCards(gameState.cards)
                                    tableau3.playCards(index)
                                } else if (tableau4.isValidTableau(
                                               gameState.cards)) {
                                    tableau4.receiveCards(gameState.cards)
                                    tableau3.playCards(index)
                                } else if (tableau5.isValidTableau(
                                               gameState.cards)) {
                                    tableau5.receiveCards(gameState.cards)
                                    tableau3.playCards(index)
                                } else if (tableau6.isValidTableau(
                                               gameState.cards)) {
                                    tableau6.receiveCards(gameState.cards)
                                    tableau3.playCards(index)
                                } else
                                    gameState.removeSnapshot()
                            }
                        }

                        DragHandler {
                            target: draggedCardImages
                            enabled: tableau3.cards[index].isShowing
                            snapMode: DragHandler.NoSnap
                            onActiveChanged: {
                                if (active) {
                                    // Start dragging the card(s)
                                    gameState.receiveCards(
                                                tableau3.copyCards(index))
                                    gameState.takeSnapshot(
                                                drawPile, wastePile,
                                                foundation0, foundation1,
                                                foundation2, foundation3,
                                                tableau0, tableau1,
                                                tableau2, tableau3,
                                                tableau4, tableau5, tableau6)
                                    gameState.dragStart = index
                                    gameState.dragSourceTableau = tableau3
                                    // Defer the model modification
                                    gameState.setIsDraggingTableau(true)
                                    draggedCardImages.visible = true
                                } else {
                                    // Handle dropping the card(s)
                                    if (root.isOverlapping(
                                                draggedCardImages,
                                                foundation_0Border)) {
                                        if (foundation0.isValidTableau(
                                                    gameState.cards)) {
                                            foundation0.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau3.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_1Border)) {
                                        if (foundation1.isValidTableau(
                                                    gameState.cards)) {
                                            foundation1.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau3.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_2Border)) {
                                        if (foundation2.isValidTableau(
                                                    gameState.cards)) {
                                            foundation2.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau3.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_3Border)) {
                                        if (foundation3.isValidTableau(
                                                    gameState.cards)) {
                                            foundation3.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau3.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_0Border)) {
                                        if (tableau0.isValidTableau(
                                                    gameState.cards)) {
                                            tableau0.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau3.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_1Border)) {
                                        if (tableau1.isValidTableau(
                                                    gameState.cards)) {
                                            tableau1.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau3.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_2Border)) {
                                        if (tableau2.isValidTableau(
                                                    gameState.cards)) {
                                            tableau2.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau3.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_3Border)) {
                                        if (tableau3.isValidTableau(
                                                    gameState.cards)) {
                                            tableau3.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau3.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_4Border)) {
                                        if (tableau4.isValidTableau(
                                                    gameState.cards)) {
                                            tableau4.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau3.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_5Border)) {
                                        if (tableau5.isValidTableau(
                                                    gameState.cards)) {
                                            tableau5.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau3.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_6Border)) {
                                        if (tableau6.isValidTableau(
                                                    gameState.cards)) {
                                            tableau6.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau3.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else {
                                        gameState.removeSnapshot()
                                        gameState.setIsDraggingTableau(false)
                                        draggedCardImages.visible = false
                                        gameState.dragStart = -1
                                        gameState.dragSourceTableau = null
                                    }
                                }
                                //onCentroidChanged: {
                                //    if (gameState.isDraggingTableau) {
                                //        var globalPos = tableau3CardImage.mapToItem(
                                //                    root, centroid.position.x,
                                //                    centroid.position.y)
                                //        draggedCardImages.x = globalPos.x
                                //                - draggedCardImages.width / 2
                                //        draggedCardImages.y = globalPos.y
                                //                - draggedCardImages.height / 2
                                //    }
                                //}
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: tableau_4Border
                width: deck.width
                height: deck.height + (tableau4.count > 1 ? (.20 * deck.height)
                                                            * (tableau4.count - 1) : 0)
                y: tableau_0Border.y
                anchors {
                    left: tableau_3Border.right
                    margins: parent.width / 43
                }
                color: "green"
                Rectangle {
                    width: parent.width
                    height: deck.height
                    border.color: "black"
                    border.width: 1
                    radius: 3
                    color: "green"
                }
                Repeater {
                    model: tableau4 ? tableau4.count : 0
                    delegate: Image {
                        id: tableau4CardImage
                        width: deck.width
                        height: deck.height
                        x: 0
                        y: index * deck.height * 0.20
                        source: tableau4.cards[index].imagePath

                        // Property to determine if this card is being dragged
                        property bool isBeingDragged: gameState.isDraggingTableau
                                                      && index >= gameState.dragStart
                                                      && gameState.dragSourceTableau === tableau4

                        // Adjust opacity based on whether the card is being dragged
                        opacity: isBeingDragged ? 0 : 1

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                draggedCardImages.x = tableau_4Border.x
                                draggedCardImages.y = this.mapToItem(null, 0,
                                                                     0).y
                            }
                            onDoubleClicked: {
                                gameState.receiveCards(
                                            tableau4.copyCards(index))
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)
                                if (foundation0.isValidTableau(
                                            gameState.cards)) {
                                    foundation0.receiveTableau(gameState.cards)
                                    tableau4.playCards(index)
                                } else if (foundation1.isValidTableau(
                                               gameState.cards)) {
                                    foundation1.receiveTableau(gameState.cards)
                                    tableau4.playCards(index)
                                } else if (foundation2.isValidTableau(
                                               gameState.cards)) {
                                    foundation2.receiveTableau(gameState.cards)
                                    tableau4.playCards(index)
                                } else if (foundation3.isValidTableau(
                                               gameState.cards)) {
                                    foundation3.receiveTableau(gameState.cards)
                                    tableau4.playCards(index)
                                } else if (tableau0.isValidTableau(
                                               gameState.cards)) {
                                    tableau0.receiveCards(gameState.cards)
                                    tableau4.playCards(index)
                                } else if (tableau1.isValidTableau(
                                               gameState.cards)) {
                                    tableau1.receiveCards(gameState.cards)
                                    tableau4.playCards(index)
                                } else if (tableau2.isValidTableau(
                                               gameState.cards)) {
                                    tableau2.receiveCards(gameState.cards)
                                    tableau4.playCards(index)
                                } else if (tableau3.isValidTableau(
                                               gameState.cards)) {
                                    tableau3.receiveCards(gameState.cards)
                                    tableau4.playCards(index)
                                } else if (tableau5.isValidTableau(
                                               gameState.cards)) {
                                    tableau5.receiveCards(gameState.cards)
                                    tableau4.playCards(index)
                                } else if (tableau6.isValidTableau(
                                               gameState.cards)) {
                                    tableau6.receiveCards(gameState.cards)
                                    tableau4.playCards(index)
                                } else
                                    gameState.removeSnapshot()
                            }
                        }

                        DragHandler {
                            target: draggedCardImages
                            enabled: tableau4.cards[index].isShowing
                            snapMode: DragHandler.NoSnap
                            onActiveChanged: {
                                if (active) {
                                    // Start dragging the card(s)
                                    gameState.receiveCards(
                                                tableau4.copyCards(index))
                                    gameState.takeSnapshot(
                                                drawPile, wastePile,
                                                foundation0, foundation1,
                                                foundation2, foundation3,
                                                tableau0, tableau1,
                                                tableau2, tableau3,
                                                tableau4, tableau5, tableau6)
                                    gameState.dragStart = index
                                    gameState.dragSourceTableau = tableau4
                                    // Defer the model modification
                                    gameState.setIsDraggingTableau(true)
                                    draggedCardImages.visible = true
                                } else {
                                    // Handle dropping the card(s)
                                    if (root.isOverlapping(
                                                draggedCardImages,
                                                foundation_0Border)) {
                                        if (foundation0.isValidTableau(
                                                    gameState.cards)) {
                                            foundation0.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau4.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_1Border)) {
                                        if (foundation1.isValidTableau(
                                                    gameState.cards)) {
                                            foundation1.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau4.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_2Border)) {
                                        if (foundation2.isValidTableau(
                                                    gameState.cards)) {
                                            foundation2.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau4.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_3Border)) {
                                        if (foundation3.isValidTableau(
                                                    gameState.cards)) {
                                            foundation3.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau4.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_0Border)) {
                                        if (tableau0.isValidTableau(
                                                    gameState.cards)) {
                                            tableau0.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau4.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_1Border)) {
                                        if (tableau1.isValidTableau(
                                                    gameState.cards)) {
                                            tableau1.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau4.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_2Border)) {
                                        if (tableau2.isValidTableau(
                                                    gameState.cards)) {
                                            tableau2.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau4.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_3Border)) {
                                        if (tableau3.isValidTableau(
                                                    gameState.cards)) {
                                            tableau3.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau4.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_4Border)) {
                                        if (tableau4.isValidTableau(
                                                    gameState.cards)) {
                                            tableau4.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau4.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_5Border)) {
                                        if (tableau5.isValidTableau(
                                                    gameState.cards)) {
                                            tableau5.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau4.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_6Border)) {
                                        if (tableau6.isValidTableau(
                                                    gameState.cards)) {
                                            tableau6.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau4.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else {
                                        gameState.setIsDraggingTableau(false)
                                        draggedCardImages.visible = false
                                        gameState.dragStart = -1
                                        gameState.dragSourceTableau = null
                                    }
                                }
                                //onCentroidChanged: {
                                //    if (gameState.isDraggingTableau) {
                                //        var globalPos = tableau4CardImage.mapToItem(
                                //                    root, centroid.position.x,
                                //                    centroid.position.y)
                                //        draggedCardImages.x = globalPos.x
                                //                - draggedCardImages.width / 2
                                //        draggedCardImages.y = globalPos.y
                                //                - draggedCardImages.height / 2
                                //    }
                                //}
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: tableau_5Border
                width: deck.width
                height: deck.height + (tableau5.count > 1 ? (.20 * deck.height)
                                                            * (tableau5.count - 1) : 0)
                y: tableau_0Border.y
                anchors {
                    left: tableau_4Border.right
                    margins: parent.width / 43
                }
                color: "green"
                Rectangle {
                    width: parent.width
                    height: deck.height
                    border.color: "black"
                    border.width: 1
                    radius: 3
                    color: "green"
                }
                Repeater {
                    model: tableau5 ? tableau5.count : 0
                    delegate: Image {
                        id: tableau5CardImage
                        width: deck.width
                        height: deck.height
                        x: 0
                        y: index * deck.height * 0.20
                        source: tableau5.cards[index].imagePath

                        // Property to determine if this card is being dragged
                        property bool isBeingDragged: gameState.isDraggingTableau
                                                      && index >= gameState.dragStart
                                                      && gameState.dragSourceTableau === tableau5

                        // Adjust opacity based on whether the card is being dragged
                        opacity: isBeingDragged ? 0 : 1

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                draggedCardImages.x = tableau_5Border.x
                                draggedCardImages.y = this.mapToItem(null, 0,
                                                                     0).y
                            }
                            onDoubleClicked: {
                                gameState.receiveCards(
                                            tableau5.copyCards(index))
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)
                                if (foundation0.isValidTableau(
                                            gameState.cards)) {
                                    foundation0.receiveTableau(gameState.cards)
                                    tableau5.playCards(index)
                                } else if (foundation1.isValidTableau(
                                               gameState.cards)) {
                                    foundation1.receiveTableau(gameState.cards)
                                    tableau5.playCards(index)
                                } else if (foundation2.isValidTableau(
                                               gameState.cards)) {
                                    foundation2.receiveTableau(gameState.cards)
                                    tableau5.playCards(index)
                                } else if (foundation3.isValidTableau(
                                               gameState.cards)) {
                                    foundation3.receiveTableau(gameState.cards)
                                    tableau5.playCards(index)
                                } else if (tableau0.isValidTableau(
                                               gameState.cards)) {
                                    tableau0.receiveCards(gameState.cards)
                                    tableau5.playCards(index)
                                } else if (tableau1.isValidTableau(
                                               gameState.cards)) {
                                    tableau1.receiveCards(gameState.cards)
                                    tableau5.playCards(index)
                                } else if (tableau2.isValidTableau(
                                               gameState.cards)) {
                                    tableau2.receiveCards(gameState.cards)
                                    tableau5.playCards(index)
                                } else if (tableau3.isValidTableau(
                                               gameState.cards)) {
                                    tableau3.receiveCards(gameState.cards)
                                    tableau5.playCards(index)
                                } else if (tableau4.isValidTableau(
                                               gameState.cards)) {
                                    tableau4.receiveCards(gameState.cards)
                                    tableau5.playCards(index)
                                } else if (tableau6.isValidTableau(
                                               gameState.cards)) {
                                    tableau6.receiveCards(gameState.cards)
                                    tableau5.playCards(index)
                                } else
                                    gameState.removeSnapshot()
                            }
                        }

                        DragHandler {
                            target: draggedCardImages
                            enabled: tableau5.cards[index].isShowing
                            snapMode: DragHandler.NoSnap
                            onActiveChanged: {
                                if (active) {
                                    // Start dragging the card(s)
                                    gameState.receiveCards(
                                                tableau5.copyCards(index))
                                    gameState.takeSnapshot(
                                                drawPile, wastePile,
                                                foundation0, foundation1,
                                                foundation2, foundation3,
                                                tableau0, tableau1,
                                                tableau2, tableau3,
                                                tableau4, tableau5, tableau6)
                                    gameState.dragStart = index
                                    gameState.dragSourceTableau = tableau5
                                    // Defer the model modification
                                    gameState.setIsDraggingTableau(true)
                                    draggedCardImages.visible = true
                                } else {
                                    // Handle dropping the card(s)
                                    if (root.isOverlapping(
                                                draggedCardImages,
                                                foundation_0Border)) {
                                        if (foundation0.isValidTableau(
                                                    gameState.cards)) {
                                            foundation0.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau5.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_1Border)) {
                                        if (foundation1.isValidTableau(
                                                    gameState.cards)) {
                                            foundation1.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau5.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_2Border)) {
                                        if (foundation2.isValidTableau(
                                                    gameState.cards)) {
                                            foundation2.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau5.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_3Border)) {
                                        if (foundation3.isValidTableau(
                                                    gameState.cards)) {
                                            foundation3.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau5.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_0Border)) {
                                        if (tableau0.isValidTableau(
                                                    gameState.cards)) {
                                            tableau0.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau5.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_1Border)) {
                                        if (tableau1.isValidTableau(
                                                    gameState.cards)) {
                                            tableau1.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau5.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_2Border)) {
                                        if (tableau2.isValidTableau(
                                                    gameState.cards)) {
                                            tableau2.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau5.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_3Border)) {
                                        if (tableau3.isValidTableau(
                                                    gameState.cards)) {
                                            tableau3.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau5.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_4Border)) {
                                        if (tableau4.isValidTableau(
                                                    gameState.cards)) {
                                            tableau4.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau5.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_5Border)) {
                                        if (tableau5.isValidTableau(
                                                    gameState.cards)) {
                                            tableau5.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau5.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_6Border)) {
                                        if (tableau6.isValidTableau(
                                                    gameState.cards)) {
                                            tableau6.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau5.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else {
                                        gameState.setIsDraggingTableau(false)
                                        draggedCardImages.visible = false
                                        gameState.dragStart = -1
                                        gameState.dragSourceTableau = null
                                    }
                                }
                            }
                        }
                    }
                }
            }
            Rectangle {
                id: tableau_6Border
                width: deck.width
                height: deck.height + (tableau6.count > 1 ? (.20 * deck.height)
                                                            * (tableau6.count - 1) : 0)
                y: tableau_0Border.y
                anchors {
                    left: tableau_5Border.right
                    margins: parent.width / 43
                }
                color: "green"
                Rectangle {
                    width: parent.width
                    height: deck.height
                    border.color: "black"
                    border.width: 1
                    radius: 3
                    color: "green"
                }
                Repeater {
                    model: tableau6 ? tableau6.count : 0
                    delegate: Image {
                        id: tableau6CardImage
                        width: deck.width
                        height: deck.height
                        x: 0
                        y: index * deck.height * 0.20
                        source: tableau6.cards[index].imagePath

                        // Property to determine if this card is being dragged
                        property bool isBeingDragged: gameState.isDraggingTableau
                                                      && index >= gameState.dragStart
                                                      && gameState.dragSourceTableau === tableau6

                        // Adjust opacity based on whether the card is being dragged
                        opacity: isBeingDragged ? 0 : 1

                        MouseArea {
                            anchors.fill: parent
                            onPressed: {
                                draggedCardImages.x = tableau_6Border.x
                                draggedCardImages.y = this.mapToItem(null, 0,
                                                                     0).y
                            }
                            onDoubleClicked: {
                                gameState.receiveCards(
                                            tableau6.copyCards(index))
                                gameState.takeSnapshot(
                                            drawPile, wastePile,
                                            foundation0, foundation1,
                                            foundation2, foundation3,
                                            tableau0, tableau1,
                                            tableau2, tableau3,
                                            tableau4, tableau5, tableau6)
                                if (foundation0.isValidTableau(
                                            gameState.cards)) {
                                    foundation0.receiveTableau(gameState.cards)
                                    tableau6.playCards(index)
                                } else if (foundation1.isValidTableau(
                                               gameState.cards)) {
                                    foundation1.receiveTableau(gameState.cards)
                                    tableau6.playCards(index)
                                } else if (foundation2.isValidTableau(
                                               gameState.cards)) {
                                    foundation2.receiveTableau(gameState.cards)
                                    tableau6.playCards(index)
                                } else if (foundation3.isValidTableau(
                                               gameState.cards)) {
                                    foundation3.receiveTableau(gameState.cards)
                                    tableau6.playCards(index)
                                } else if (tableau0.isValidTableau(
                                               gameState.cards)) {
                                    tableau0.receiveCards(gameState.cards)
                                    tableau6.playCards(index)
                                } else if (tableau1.isValidTableau(
                                               gameState.cards)) {
                                    tableau1.receiveCards(gameState.cards)
                                    tableau6.playCards(index)
                                } else if (tableau2.isValidTableau(
                                               gameState.cards)) {
                                    tableau2.receiveCards(gameState.cards)
                                    tableau6.playCards(index)
                                } else if (tableau3.isValidTableau(
                                               gameState.cards)) {
                                    tableau3.receiveCards(gameState.cards)
                                    tableau6.playCards(index)
                                } else if (tableau4.isValidTableau(
                                               gameState.cards)) {
                                    tableau4.receiveCards(gameState.cards)
                                    tableau6.playCards(index)
                                } else if (tableau5.isValidTableau(
                                               gameState.cards)) {
                                    tableau5.receiveCards(gameState.cards)
                                    tableau6.playCards(index)
                                } else
                                    gameState.removeSnapshot()
                            }
                        }

                        DragHandler {
                            target: draggedCardImages
                            enabled: tableau6.cards[index].isShowing
                            snapMode: DragHandler.NoSnap
                            onActiveChanged: {
                                if (active) {
                                    // Start dragging the card(s)
                                    gameState.receiveCards(
                                                tableau6.copyCards(index))
                                    gameState.takeSnapshot(
                                                drawPile, wastePile,
                                                foundation0, foundation1,
                                                foundation2, foundation3,
                                                tableau0, tableau1,
                                                tableau2, tableau3,
                                                tableau4, tableau5, tableau6)
                                    gameState.dragStart = index
                                    gameState.dragSourceTableau = tableau6
                                    // Defer the model modification
                                    gameState.setIsDraggingTableau(true)
                                    draggedCardImages.visible = true
                                } else {
                                    // Handle dropping the card(s)
                                    if (root.isOverlapping(
                                                draggedCardImages,
                                                foundation_0Border)) {
                                        if (foundation0.isValidTableau(
                                                    gameState.cards)) {
                                            foundation0.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau6.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_1Border)) {
                                        if (foundation1.isValidTableau(
                                                    gameState.cards)) {
                                            foundation1.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau6.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_2Border)) {
                                        if (foundation2.isValidTableau(
                                                    gameState.cards)) {
                                            foundation2.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau6.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   foundation_3Border)) {
                                        if (foundation3.isValidTableau(
                                                    gameState.cards)) {
                                            foundation3.receiveTableau(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau6.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_0Border)) {
                                        if (tableau0.isValidTableau(
                                                    gameState.cards)) {
                                            tableau0.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau6.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_1Border)) {
                                        if (tableau1.isValidTableau(
                                                    gameState.cards)) {
                                            tableau1.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau6.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_2Border)) {
                                        if (tableau2.isValidTableau(
                                                    gameState.cards)) {
                                            tableau2.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau6.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_3Border)) {
                                        if (tableau3.isValidTableau(
                                                    gameState.cards)) {
                                            tableau3.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau6.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_4Border)) {
                                        if (tableau4.isValidTableau(
                                                    gameState.cards)) {
                                            tableau4.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau6.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_5Border)) {
                                        if (tableau5.isValidTableau(
                                                    gameState.cards)) {
                                            tableau5.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau6.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else if (root.isOverlapping(
                                                   draggedCardImages,
                                                   tableau_6Border)) {
                                        if (tableau6.isValidTableau(
                                                    gameState.cards)) {
                                            tableau6.receiveCards(
                                                        gameState.cards)
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                            Qt.callLater(function () {
                                                tableau6.playCards(index)
                                            })
                                        } else {
                                            gameState.setIsDraggingTableau(
                                                        false)
                                            draggedCardImages.visible = false
                                            gameState.dragStart = -1
                                            gameState.dragSourceTableau = null
                                        }
                                    } else {
                                        gameState.removeSnapshot()
                                        gameState.setIsDraggingTableau(false)
                                        draggedCardImages.visible = false
                                        gameState.dragStart = -1
                                        gameState.dragSourceTableau = null
                                    }
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}
