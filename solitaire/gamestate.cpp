#include "gamestate.h"
#include <QDebug>
#include <algorithm> // For std::shuffle
#include <random>    // For std::random_device and std::mt19937

GameState::GameState(QObject *parent)
    : QObject{parent}, timer(new QTimer(this)), timeElapsed(new QTime(0, 0))
{
    m_draggedCard = nullptr;
    m_isDragging = false;
    m_count = 0;
    m_isDraggingTableau = false;
    m_dragStart = -1;
    m_dragSourceTableau = nullptr;
    m_score = 0;
    connect(timer, &QTimer::timeout, this, [=]() {
        *timeElapsed = timeElapsed->addSecs(1);  // Increment the time by 1 second
        emit timeStringChanged();  // Notify QML to update the displayed time
    });
}

int GameState::finalScore()
{
    float finalTime = QTime(0, 0).secsTo(*timeElapsed);
    float ratio = (300 - finalTime) / 300;
    if(ratio < -.5)
        ratio = -.5;
    float timeMultiplier = 1 + ratio;
    int result = score() * timeMultiplier;
    return result;
}

int GameState::score() const
{
    return m_score + m_nonFoundationScore;
}

void GameState::changeScore(int change)
{
    m_nonFoundationScore += change;
    emit scoreChanged();
}

void GameState::calcFoundationScore(foundation *foundation0, foundation *foundation1, foundation *foundation2, foundation *foundation3)
{
    int totalCards = 0;
    totalCards += foundation0->cardCount();
    totalCards += foundation1->cardCount();
    totalCards += foundation2->cardCount();
    totalCards += foundation3->cardCount();
    m_score = 100 * totalCards;
    emit scoreChanged();
}

tableau *GameState::getDragSourceTableau()
{
    return m_dragSourceTableau;
}

void GameState::setDragSourceTableau(tableau *tableauRef)
{
    m_dragSourceTableau = tableauRef;
    emit dragSourceTableauChanged();
}

int GameState::getDragStart()
{
    return m_dragStart;
}

void GameState::setDragStart(int index)
{
    m_dragStart = index;
    emit dragStartChanged();
}

QObject* GameState::getDraggedCard() const
{
    //if(m_draggedCard == nullptr)
    //    qWarning() << "draggedCard is a nullptr GameState::getDraggedCard";
    QObject* temp = m_draggedCard;
    //if(temp == nullptr)
    //    qWarning() << "GameState::getDraggedCard is returning a nullptr";
    return temp;
}

bool GameState::getIsDragging() const
{
    return m_isDragging;
}

void GameState::setIsDragging(bool isDragging)
{

    m_isDragging = isDragging;
    emit isDraggingChanged();
}

void GameState::setDraggedCard(QObject* obj)
{
    if(obj == nullptr)
        qWarning() << "GameState::setDraggedCard received a nullptr";
    card* c = qobject_cast<card *>(obj);
    if(c)
    {
        m_draggedCard = c;
        emit draggedCardChanged();
        if(m_draggedCard == nullptr)
            qWarning() << "GameState::setDraggedCard draggedCard is being set to nullptr";
    }
    else
        qWarning() << "Failed to cast QObject to card* GameState::setDraggedCard";
}

QList<QObject*> GameState::getCards() const
{
    QList<QObject*> cardList;
    for (card* card : m_cards) {
        cardList.append(card);
    }
    return cardList;
}

bool GameState::getIsDraggingTableau() const
{
    return m_isDraggingTableau;
}

void GameState::setIsDraggingTableau(bool isDragging)
{
    m_isDraggingTableau = isDragging;
    emit isDraggingTableauChanged();
}

void GameState::receiveCards(QList<QObject*> cards)
{
    m_cards.clear();
    m_count = 0;
    for(QObject* cardObject : cards)
    {
        if(cardObject == nullptr)
            qWarning() << "received a nullptr GameState::receiveCards";
        card* c = qobject_cast<card*>(cardObject);  // Safe cast to 'card*'
        if (c) {
            //c->setParent(this); // Set parent to GameState
            m_cards.append(c);
            m_count++;
        } else {
            qWarning() << "Failed to cast QObject to card* GameState::receiveCards";
        }
    }
    emit cardsChanged();
    emit countChanged();
}

void GameState::resetDragState()
{
    m_draggedCard = nullptr;
    emit draggedCardChanged();
    m_isDragging = false;
    emit isDraggingChanged();
}

void GameState::setInitialCards(QList<card *> initial)
{
    initialCards = initial;
}

void GameState::resetGame(drawPile *deck, waste *wastePile, foundation *foundation0, foundation *foundation1, foundation *foundation2, foundation *foundation3, tableau *tableau0, tableau *tableau1, tableau *tableau2, tableau *tableau3, tableau *tableau4, tableau *tableau5, tableau *tableau6)
{
    hasWon = false;
    emit hasWonChanged();

    m_score = 0;
    m_nonFoundationScore = 0;
    emit scoreChanged();

    deck->clear();
    wastePile->clear();
    foundation0->clear();
    foundation1->clear();
    foundation2->clear();
    foundation3->clear();
    tableau0->clear();
    tableau1->clear();
    tableau2->clear();
    tableau3->clear();
    tableau4->clear();
    tableau5->clear();
    tableau6->clear();

    QList<card*> distributeCards = initialCards;
    shuffle(distributeCards);

    tableau0->initializeTableau(distributeCards, 1); // This will take cards from initial cards for each tableau pile.
    tableau1->initializeTableau(distributeCards, 2);
    tableau2->initializeTableau(distributeCards, 3);
    tableau3->initializeTableau(distributeCards, 4);
    tableau4->initializeTableau(distributeCards, 5);
    tableau5->initializeTableau(distributeCards, 6);
    tableau6->initializeTableau(distributeCards, 7);

    deck->initializeDeck(distributeCards);
}

void GameState::shuffle(QList<card *> &pile)
{
    std::random_device rd;  // Obtain a random number from hardware
    std::mt19937 g(rd());   // Seed the generator

    // Use std::shuffle with QList iterators
    std::shuffle(pile.begin(), pile.end(), g);
}

void GameState::takeSnapshot(drawPile *deck, waste *wastePile, foundation *foundation0, foundation *foundation1, foundation *foundation2, foundation *foundation3, tableau *tableau0, tableau *tableau1, tableau *tableau2, tableau *tableau3, tableau *tableau4, tableau *tableau5, tableau *tableau6)
{
    GameStateSnapshot snapshot;
    snapshot.deckState = deck->getCards();
    snapshot.wastePileState = wastePile->getCards();
    snapshot.foundation0State = foundation0->getCards();
    snapshot.foundation1State = foundation1->getCards();
    snapshot.foundation2State = foundation2->getCards();
    snapshot.foundation3State = foundation3->getCards();
    snapshot.tableau0State = tableau0->getCards();
    snapshot.tableau1State = tableau1->getCards();
    snapshot.tableau2State = tableau2->getCards();
    snapshot.tableau3State = tableau3->getCards();
    snapshot.tableau4State = tableau4->getCards();
    snapshot.tableau5State = tableau5->getCards();
    snapshot.tableau6State = tableau6->getCards();
    snapshot.tableau0IsShowings = tableau0->getIsShowings();
    snapshot.tableau1IsShowings = tableau1->getIsShowings();
    snapshot.tableau2IsShowings = tableau2->getIsShowings();
    snapshot.tableau3IsShowings = tableau3->getIsShowings();
    snapshot.tableau4IsShowings = tableau4->getIsShowings();
    snapshot.tableau5IsShowings = tableau5->getIsShowings();
    snapshot.tableau6IsShowings = tableau6->getIsShowings();
    gameStateHistory.push(snapshot);
}

void GameState::removeSnapshot()
{
    gameStateHistory.pop();
}

void GameState::undo(drawPile *deck, waste *wastePile, foundation *foundation0, foundation *foundation1, foundation *foundation2, foundation *foundation3, tableau *tableau0, tableau *tableau1, tableau *tableau2, tableau *tableau3, tableau *tableau4, tableau *tableau5, tableau *tableau6)
{
    if (!gameStateHistory.isEmpty()) {
        // Pop the last saved game state
        changeScore(-20);
        GameStateSnapshot snapshot = gameStateHistory.pop();

        deck->clear();
        wastePile->clear();
        foundation0->clear();
        foundation1->clear();
        foundation2->clear();
        foundation3->clear();
        tableau0->clear();
        tableau1->clear();
        tableau2->clear();
        tableau3->clear();
        tableau4->clear();
        tableau5->clear();
        tableau6->clear();

        deck->receiveCards(snapshot.deckState);
        wastePile->receiveCards(snapshot.wastePileState);

        foundation0->receiveTableau(snapshot.foundation0State);
        foundation1->receiveTableau(snapshot.foundation1State);
        foundation2->receiveTableau(snapshot.foundation2State);
        foundation3->receiveTableau(snapshot.foundation3State);

        tableau0->receiveCards(snapshot.tableau0State);
        tableau1->receiveCards(snapshot.tableau1State);
        tableau2->receiveCards(snapshot.tableau2State);
        tableau3->receiveCards(snapshot.tableau3State);
        tableau4->receiveCards(snapshot.tableau4State);
        tableau5->receiveCards(snapshot.tableau5State);
        tableau6->receiveCards(snapshot.tableau6State);

        tableau0->flipCards(snapshot.tableau0IsShowings);
        tableau1->flipCards(snapshot.tableau1IsShowings);
        tableau2->flipCards(snapshot.tableau2IsShowings);
        tableau3->flipCards(snapshot.tableau3IsShowings);
        tableau4->flipCards(snapshot.tableau4IsShowings);
        tableau5->flipCards(snapshot.tableau5IsShowings);
        tableau6->flipCards(snapshot.tableau6IsShowings);
    }

}

int GameState::getCount() const
{
    return m_count;
}

bool GameState::getHasWon()
{
    return hasWon;
}

void GameState::checkWin(foundation *foundation0, foundation *foundation1, foundation *foundation2, foundation *foundation3)
{
    if(foundation0->cardCount() == 13 && foundation1->cardCount() == 13 && foundation2->cardCount() == 13 && foundation3->cardCount() == 13)
    {
        hasWon = true;
        stopTimer();
        emit hasWonChanged();
        emit finalScoreChanged();
    }
}

QString GameState::timeString() const {
    return timeElapsed->toString("mm:ss");  // Return formatted time as "minutes:seconds"
}

void GameState::startTimer() {
    if (!timer->isActive()) {
        timer->start(1000);  // Start the timer to trigger every second
    }
}

void GameState::stopTimer() {
    timer->stop();  // Stop the timer
}

void GameState::resetTimer() {
    //timer->stop();  // Stop the timer
    timer->start();
    *timeElapsed = QTime(0, 0);  // Reset the elapsed time to 0
    emit timeStringChanged();  // Update the displayed time in QML
}
