#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QQuickWindow>
#include <QSGRendererInterface>
#include "draw.h"
#include "foundation.h"
#include "tableau.h"
#include "waste.h"
#include "gamestate.h"
#include <algorithm> // For std::shuffle
#include <random>    // For std::random_device and std::mt19937

void shuffle(QList<card*>& deck) {
    std::random_device rd;  // Obtain a random number from hardware
    std::mt19937 g(rd());   // Seed the generator

    // Use std::shuffle with QList iterators
    std::shuffle(deck.begin(), deck.end(), g);
}

int main(int argc, char *argv[])
{
    qputenv("QSG_RENDER_LOOP", "basic"); //Disbale V-sync

    QGuiApplication app(argc, argv);

    QQuickWindow::setGraphicsApi(QSGRendererInterface::OpenGLRhi);  //Force OpenGl instead of DirectX since it was having rendering issues

    QQmlApplicationEngine engine;

    QList<card*> initialCards;
    tableau tableauPiles[7];      // Created 7 tableua piles using the default constructor
    waste wastePile;            // Create the waste pile using the default constructor
    foundation foundationPiles[4]; // Create 4 foundation piles using the default constructor
    for (int i = 0; i < 4; i++)
        for (int j = 0; j < 13; j++)
        {
            QString suitPath;

            // Determine the folder name based on the suit
            if (i == 0)
                suitPath = "diamonds";
            else if (i == 1)
                suitPath = "clubs";
            else if (i == 2)
                suitPath = "hearts";
            else
                suitPath = "spades";

            // Construct the full relative file path for the SVG
            QString cardImagePath = QString("images/%1/%2.svg").arg(suitPath).arg(j);

            // Create the card object with rank, suit, and image path
            initialCards.append(new card(rankList[j], suitList[i], cardImagePath));
        }
    for(card* c : initialCards)
    {
        QQmlEngine::setObjectOwnership(c, QQmlEngine::CppOwnership);
    }
    GameState gameState;
    gameState.setInitialCards(initialCards);
    gameState.startTimer();
    shuffle(initialCards);          // Shuffle cards

    for (int i = 0; i < 7; i++)                // Set up tableaus
        tableauPiles[i].initializeTableau(initialCards, i+1); // This will take cards from initial cards for each tableau pile.
    drawPile drawPile(initialCards);         // Rest of the cards go into the draw pile


    // Expose C++ instances to QML
    engine.rootContext()->setContextProperty("gameState", &gameState);
    //QQmlEngine::setObjectOwnership(&gameState, QQmlEngine::CppOwnership);

    engine.rootContext()->setContextProperty("drawPile", &drawPile);
    engine.rootContext()->setContextProperty("wastePile", &wastePile);

    for (int i = 0; i < 4; ++i) {
        QString name = QString("foundation%1").arg(i);
        engine.rootContext()->setContextProperty(name, &foundationPiles[i]); //foundation0,1,2,3
    }

    for (int i = 0; i < 7; ++i) {
        QString name = QString("tableau%1").arg(i);
        engine.rootContext()->setContextProperty(name, &tableauPiles[i]);
    }

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);
    engine.loadFromModule("qml-solitaire", "Main");

    // Check for loading errors
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
