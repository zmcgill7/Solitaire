#include "waste.h"
#include <QDebug>

waste::waste(QObject *parent)
    : QObject{parent}
{}

// Get the list of cards (converted to QList<QObject*> for QML)
QList<QObject*> waste::getCards() const {
    QList<QObject*> cardList;
    for (card* card : m_cards) {
        if(card == nullptr)
            qWarning() << "waste::getCards() just appended a nullptr";
        cardList.append(card);
    }
    return cardList;
}

// Get the number of cards in the waste pile
int waste::cardCount() const {
    return m_cards.size();
}

// Get the top card of the waste pile (last card in the list)
 QObject* waste::topCard() const {
    if (m_cards.isEmpty()) {
        //qWarning() << "waste::topCard() just returned a nullptr because m_cards is empty";
        return nullptr;
    }
    else
    {
        QObject* temp = m_cards.last();
        if(temp == nullptr)
            qWarning() << "waste::topCard() just returned a nullptr";
        return temp;
    }
}

// Receive a card from the deck or draw pile
void waste::receiveDraw(drawPile *drawPile)
{
    card* card = drawPile->drawCard();  // Attempt to draw a card from the draw pile
    if (card != nullptr)
    {
        card->setShowing(true);         // The card is now face-up when added to the waste pile
        m_cards.append(card);           // Add card to the waste pile
        emit cardsChanged();            // Notify that the cards have changed
        emit topCardChanged();          // Notify that the top card has changed
    }
    else
    {
        // If the draw pile is exhausted, reset it with the waste pile's cards
        drawPile->populateDeck(m_cards);
        m_cards.clear();                        // Clear the waste pile after resetting the draw pile
        emit cardsChanged();
        emit topCardChanged();
    }
}

void waste::receiveCard(QObject* obj)
{
    if(obj == nullptr)
        qWarning() << "obj was null waste::receiveCard";
    card* c = qobject_cast<card *>(obj);
    if (c) {
        m_cards.append(c);           // Add card to the waste pile
        emit cardsChanged();            // Notify that the cards have changed
        emit topCardChanged();          // Notify that the top card has changed
    }
    else
        qWarning() << "Failed to cast QObject to card* waste::receiveCard";
}

QObject* waste::playCard()
{
    if (m_cards.isEmpty()) {
        qWarning() << "waste had playCard called and m_cards evaluated to empty";
        return nullptr;
    }
    QObject* cardObj = m_cards.takeLast();
    emit cardsChanged();
    emit topCardChanged();
    if(cardObj == nullptr)
    {
        qWarning() << "waste::playCard() just returned a nullptr";
    }
    return cardObj;
}

void waste::receiveCards(QList<QObject *> cardsObj)
{
    QList<card*> cards;
    for(auto obj : cardsObj)
    {
        card* c = qobject_cast<card *>(obj);
        c->setShowing(true);
        cards.append(c);
    }
    m_cards.append(cards);
    emit topCardChanged();
    emit cardsChanged();
}

void waste::clear()
{
    m_cards.clear();
    emit topCardChanged();
}

void waste::deleteCards()
{
    for (card* c : m_cards) {
        delete c;  // Free the memory for each card object
    }
    m_cards.clear();
}

waste::~waste()
{
    deleteCards();
}

