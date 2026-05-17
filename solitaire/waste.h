#ifndef WASTE_H
#define WASTE_H


#include <QObject>
#include <QList>
#include "card.h"
#include "draw.h"

class waste : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> cards READ getCards NOTIFY cardsChanged) // Expose list of cards
    Q_PROPERTY(int cardCount READ cardCount NOTIFY cardsChanged)        // Expose card count
    Q_PROPERTY(QObject* topCard READ topCard NOTIFY topCardChanged)        // Expose top card

public:
    explicit waste(QObject *parent = nullptr);

    // Getter for cards
    QList<QObject*> getCards() const;

    // Get the number of cards in the waste pile
    int cardCount() const;

    // Get the top card of the waste pile (last card in the list)
    QObject* topCard() const; ////

    // Receive a card from the deck or draw pile
    Q_INVOKABLE void receiveDraw(drawPile *drawPile);
    Q_INVOKABLE void receiveCard(QObject* card); /////
    Q_INVOKABLE QObject* playCard(); ////
    void receiveCards(QList<QObject*> cards);
    void clear();
    void deleteCards();
    ~waste();

signals:
    void cardsChanged();    // Signal to notify that the cards have changed
    void topCardChanged();  // Signal to notify that the top card has changed

private:
    QList<card*> m_cards;   // Internal list of card pointers
};

#endif // WASTE_H
