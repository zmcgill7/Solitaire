#ifndef GAMESTATE_H
#define GAMESTATE_H

#include <QObject>
#include "foundation.h"
#include "tableau.h"
#include "waste.h"
#include "draw.h"
#include "card.h"
#include <QStack>
#include <QTimer>
#include <QTime>

struct GameStateSnapshot {
    QList<QObject*> deckState;
    QList<QObject*> wastePileState;
    QList<QObject*> foundation0State;
    QList<QObject*> foundation1State;
    QList<QObject*> foundation2State;
    QList<QObject*> foundation3State;
    QList<QObject*> tableau0State;
    QList<QObject*> tableau1State;
    QList<QObject*> tableau2State;
    QList<QObject*> tableau3State;
    QList<QObject*> tableau4State;
    QList<QObject*> tableau5State;
    QList<QObject*> tableau6State;
    QList<bool> tableau0IsShowings;
    QList<bool> tableau1IsShowings;
    QList<bool> tableau2IsShowings;
    QList<bool> tableau3IsShowings;
    QList<bool> tableau4IsShowings;
    QList<bool> tableau5IsShowings;
    QList<bool> tableau6IsShowings;
};

class GameState : public QObject
{
    Q_OBJECT
public:
    explicit GameState(QObject *parent = nullptr);
    Q_PROPERTY(QObject* draggedCard READ getDraggedCard WRITE setDraggedCard NOTIFY draggedCardChanged)
    Q_PROPERTY(bool isDragging READ getIsDragging WRITE setIsDragging NOTIFY isDraggingChanged)
    Q_PROPERTY(QList<QObject*> cards READ getCards NOTIFY cardsChanged)
    Q_PROPERTY(bool isDraggingTableau READ getIsDraggingTableau WRITE setIsDraggingTableau NOTIFY isDraggingTableauChanged)
    Q_PROPERTY(int multiCount READ getCount NOTIFY countChanged)
    Q_PROPERTY(int dragStart READ getDragStart WRITE setDragStart NOTIFY dragStartChanged)
    Q_PROPERTY(tableau* dragSourceTableau READ getDragSourceTableau WRITE setDragSourceTableau NOTIFY dragSourceTableauChanged)
    Q_PROPERTY(QString timeString READ timeString NOTIFY timeStringChanged)
    Q_PROPERTY(int score READ score NOTIFY scoreChanged)
    Q_PROPERTY(bool hasWon READ getHasWon NOTIFY hasWonChanged)
    Q_PROPERTY(int finalScore READ finalScore NOTIFY finalScoreChanged)

    int finalScore();

    int score() const;
    void changeScore(int change);
    Q_INVOKABLE void calcFoundationScore(foundation *foundation0, foundation *foundation1, foundation *foundation2, foundation *foundation3);

    tableau* getDragSourceTableau();
    void setDragSourceTableau(tableau* tableauRef);

    int getDragStart();
    void setDragStart(int index);

    // Getter and setter for draggedCard
    QObject* getDraggedCard() const; ////
    bool getIsDragging() const;
    Q_INVOKABLE void setIsDragging(bool isDragging);
    Q_INVOKABLE void setDraggedCard(QObject* card); ////

    QList<QObject*> getCards() const;
    bool getIsDraggingTableau() const;
    Q_INVOKABLE void setIsDraggingTableau(bool isDragging);
    Q_INVOKABLE void receiveCards(QList<QObject*> cards);

    //Timer methods
    Q_INVOKABLE void startTimer();
    Q_INVOKABLE void stopTimer();
    Q_INVOKABLE void resetTimer();
    QString timeString() const;

    // Method to reset the dragged card and source pile
    Q_INVOKABLE void resetDragState();
    void setInitialCards(QList<card*> initial);
    Q_INVOKABLE void resetGame(drawPile *deck, waste *wastePile, foundation *foundation0, foundation *foundation1, foundation *foundation2, foundation *foundation3, tableau *tableau0, tableau *tableau1, tableau *tableau2, tableau *tableau3, tableau *tableau4, tableau *tableau5, tableau *tableau6);
    void shuffle(QList<card*> &pile);
    Q_INVOKABLE void takeSnapshot(drawPile *deck, waste *wastePile, foundation *foundation0, foundation *foundation1, foundation *foundation2, foundation *foundation3, tableau *tableau0, tableau *tableau1, tableau *tableau2, tableau *tableau3, tableau *tableau4, tableau *tableau5, tableau *tableau6);
    Q_INVOKABLE void removeSnapshot();
    Q_INVOKABLE void undo(drawPile *deck, waste *wastePile, foundation *foundation0, foundation *foundation1, foundation *foundation2, foundation *foundation3, tableau *tableau0, tableau *tableau1, tableau *tableau2, tableau *tableau3, tableau *tableau4, tableau *tableau5, tableau *tableau6);
    int getCount() const;
    bool getHasWon();
    Q_INVOKABLE void checkWin(foundation *foundation0, foundation *foundation1, foundation *foundation2, foundation *foundation3);

 tableau *getDragSourceTableau() const;

signals:
    void draggedCardChanged();
    void isDraggingChanged();
    void isDraggingTableauChanged();
    void cardsChanged();
    void countChanged();
    void dragStartChanged();
    void dragSourceTableauChanged();
    void timeStringChanged();
    void scoreChanged();
    void hasWonChanged();
    void finalScoreChanged();

private:
    card* m_draggedCard;  // The card currently being dragged
    bool m_isDragging;
    QList<card*> m_cards;
    bool m_isDraggingTableau;
    int m_count;
    int m_dragStart;
    tableau *m_dragSourceTableau;
    QList<card*> initialCards;
    QStack<GameStateSnapshot> gameStateHistory;
    QTimer* timer;
    QTime* timeElapsed;
    int m_score;
    int m_nonFoundationScore = 0;
    bool hasWon = false;
};

#endif // GAMESTATE_H
