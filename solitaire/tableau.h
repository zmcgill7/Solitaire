#ifndef TABLEAU_H
#define TABLEAU_H

#include <QObject>
#include <card.h>

class tableau : public QObject
{
    Q_OBJECT
public:
    explicit tableau(QObject *parent = nullptr);
    Q_PROPERTY(QList<QObject*> cards READ getCards NOTIFY cardsChanged)
    Q_PROPERTY(int count READ getCount NOTIFY countChanged)

    // Receive a card from the deck or draw pile
    Q_INVOKABLE void receiveCard(QObject* card); ////
    Q_INVOKABLE bool isValid(QObject* card); ////
    Q_INVOKABLE QList<QObject*> playCards(int index);
    Q_INVOKABLE void receiveCards(QList<QObject*> cards); /////
    Q_INVOKABLE bool isValidTableau(QList<QObject*> cards); ////
    Q_INVOKABLE QList<QObject*> copyCards(int index);
    QList<QObject*> getCards();
    int getCount();
    void initializeTableau(QList<card*> &initialCards, int numCards);
    void clear();
    void deleteCards();
    QList<bool> getIsShowings();
    void flipCards(QList<bool>);
    ~tableau();

signals:
    void cardsChanged();
    void countChanged();
private:
    QList<card*> m_cards;   // Internal list of card pointers
    int m_count;
};

#endif // TABLEAU_H
