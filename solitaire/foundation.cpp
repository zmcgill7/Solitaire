#include "foundation.h"
#include "card.h"
#include <QDebug>

foundation::foundation(QObject *parent)
    : QObject{parent}
{
    firstSuit = UNINITIALIZED;
    currentRank = ZERO;
}

QList<QObject *> foundation::getCards() const
{
    QList<QObject*> cardList;
    for (card* card : m_cards) {
        cardList.append(card);
    }
    return cardList;
}

int foundation::cardCount() const
{
    return m_cards.size();
}

QObject* foundation::topCard() const
{
    if (m_cards.isEmpty()) {
        return nullptr;
    }
    return m_cards.last();
}

void foundation::receiveCard(QObject* cardObj)
{
    card* c = qobject_cast<card *>(cardObj);
    if(c)
    {
        m_cards.append(c);           // Add card to the waste pile
        emit cardsChanged();            // Notify that the cards have changed
        emit topCardChanged();          // Notify that the top card has changed
    }
    else
        qWarning() << "Failed to cast QObject to card* foundation::receiveCard";

}

bool foundation::isValid(QObject* cardObj)
{
    if (cardObj == nullptr) {
        qWarning() << "cardObj was null foundation::isValid";
        return false;
    }
    card* c = qobject_cast<card *>(cardObj);
    if(c)
    {
        if(firstSuit == UNINITIALIZED) //Pile can become any suit
        {
            if(c->getRank() == 1)
            {
                firstSuit = c->getSuit();
                currentRank = ACE;
                return true;
            }
            else
                return false;
        }
        else //Pile suit has been set
        {
            if(firstSuit == c->getSuit()) //Card suit matches
            {
                if(c->getRank() == currentRank + 1) //Card rank follows rules
                {
                    currentRank = c->getRank();
                    return true;
                }
                else  //Card rank isn't correct
                    return false;
            }
            else //Card suit doesn't match
                return false;
        }
    }
    else
    {
        qWarning() << "Failed to cast QObject to card* foundation::isValid";
        return false;
    }
}

bool foundation::isValidTableau(QList<QObject*> cards)
{

    if(cards.size() == 1)
    {
        card* c = qobject_cast<card *>(cards[0]);
        if(c)
        {
            if(firstSuit == UNINITIALIZED) //Pile can become any suit
            {
                if(c->getRank() == 1)
                {
                    firstSuit = c->getSuit();
                    currentRank = ACE;
                    return true;
                }
                else
                    return false;
            }
            else //Pile suit has been set
            {
                if(firstSuit == c->getSuit()) //Card suit matches
                {
                    if(c->getRank() == currentRank + 1) //Card rank follows rules
                    {
                        currentRank = c->getRank();
                        return true;
                    }
                    else  //Card rank isn't correct
                        return false;
                }
                else //Card suit doesn't match
                    return false;
            }
        }
        else
        {
            qWarning() << "Failed to cast QObject to card* in foundation::isValidTableau";
        }
    }
    else
        return false;
    return false;
}

void foundation::receiveTableau(QList<QObject*> cards)
{
    if(!cards.isEmpty())
    {
        for(auto cardObj : cards)
        {
            card* c = qobject_cast<card*>(cardObj);
            if (c) {
                if(m_cards.isEmpty())
                    firstSuit = c->getSuit();
                c->setShowing(true);
                m_cards.append(c);          // Add card to the waste pile
            } else {
                qWarning() << "Failed to cast QObject to card* in foundation::receiveTableau";
            }
        }
        currentRank = m_cards.last()->getRank();
        emit cardsChanged();            // Notify that the cards have changed
        emit topCardChanged();          // Notify that the top card has changed
    }
}

QObject* foundation::playCard() //Can loop and create a Qlist for multiple cards later
{
    if (m_cards.isEmpty()) {
        return nullptr;
    }
    card* card = m_cards.takeLast();
    if(m_cards.isEmpty())
    {
        firstSuit = UNINITIALIZED;
        currentRank = ZERO;
    }
    else
        currentRank = m_cards.last()->getRank();
    emit cardsChanged();
    emit topCardChanged();
    return card;
}

void foundation::clear()
{
    m_cards.clear();
    firstSuit = UNINITIALIZED;
    currentRank = ZERO;
    emit cardsChanged();
    emit topCardChanged();
}

void foundation::deleteCards()
{
    for (card* c : m_cards) {
        delete c;  // Free the memory for each card object
    }
    m_cards.clear();
}

foundation::~foundation()
{
    deleteCards();
}

