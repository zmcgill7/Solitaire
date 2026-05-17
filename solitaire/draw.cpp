#include "draw.h"

// Default constructor
drawPile::drawPile(QObject *parent)
    : QObject(parent) {}

// Constructor with card list
drawPile::drawPile(const QList<card*> &cards, QObject *parent)
    : QObject(parent), m_cards(cards) {

}

void drawPile::initializeDeck(QList<card *> &pile)
{
    m_cards = pile;
    for(auto card : m_cards)
        card->setShowing(false);
    emit cardsChanged();
    emit topCardChanged();
}

// Get the list of cards (converted to QList<QObject*> for QML)
QList<QObject*> drawPile::getCards() const {
    QList<QObject*> cardList;
    for (card* card : m_cards) {
        cardList.append(card);
    }
    return cardList;
}

// Get the number of cards in the pile
int drawPile::cardCount() const {
    return m_cards.size();
}

// Get the top card of the deck pile (last card in the list)
card* drawPile::topCard() const {
    if (m_cards.isEmpty()) {
        return nullptr;
    }
    return m_cards.last();
}

void drawPile::receiveCards(QList<QObject *> cardsObj)
{
    for(auto obj : cardsObj)
    {
        card* c = qobject_cast<card *>(obj);
        c->setShowing(false);
        m_cards.append(c);
    }
    emit topCardChanged();
    emit cardsChanged();
}

void drawPile::populateDeck(QList<card *> cards)
{
    if (m_cards.isEmpty()) {
        // Reverse the order of the waste pile to maintain correct draw order
        std::reverse(cards.begin(), cards.end());

        // Set all cards to not showing (face-down)
        for (card* card : cards) {
            card->setShowing(false);  // Assuming there's a method in the Card class to set this
        }

        // Assign the reversed and updated cards to the deck pile
        m_cards = cards;

        // Notify QML that the deck has changed
        emit cardsChanged();
        emit topCardChanged();
    }
}


// Remove the top card from the deck pile
card* drawPile::drawCard() {
    if (m_cards.isEmpty()) {
        return nullptr;
    }
    card* card = m_cards.takeLast();
    emit cardsChanged();
    emit topCardChanged();
    return card;
}

void drawPile::clear()
{
    m_cards.clear();
}

void drawPile::deleteCards()
{
    for (card* c : m_cards) {
        delete c;  // Free the memory for each card object
    }
    m_cards.clear();
}

drawPile::~drawPile()
{
    deleteCards();
}
