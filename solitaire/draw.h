#ifndef DRAW_H
#define DRAW_H

#include <QObject>
#include <QList>
#include "card.h"

//ADD INVOKABLE KEYWORDS

class drawPile : public QObject
{
    Q_OBJECT
    Q_PROPERTY(QList<QObject*> cards READ getCards NOTIFY cardsChanged) // Expose list of cards
    Q_PROPERTY(int cardCount READ cardCount NOTIFY cardsChanged)        // Expose card count
    Q_PROPERTY(card* topCard READ topCard NOTIFY topCardChanged)        // Expose top card

public:
    explicit drawPile(QObject *parent = nullptr);                      // Default constructor
    explicit drawPile(const QList<card*> &cards, QObject *parent = nullptr);  // Constructor with card list

    void initializeDeck(QList<card*> &pile);
    // Getter for cards
    QList<QObject*> getCards() const;

    // Get the number of cards in the pile
    int cardCount() const;

    // Get the top card of the deck pile (last card in the list)
    card* topCard() const;

    void receiveCards(QList<QObject*> cards);

    // Add a card to the deck pile
    void populateDeck(QList<card*> cards);

    // Remove the top card from the deck pile
    card* drawCard();

    void clear();

    void deleteCards();
    ~drawPile();

signals:
    void cardsChanged();    // Signal to notify that the cards have changed
    void topCardChanged();  // Signal to notify that the top card has changed

private:
    QList<card*> m_cards;  // Internal list of card pointers
};


#endif // DRAW_H
