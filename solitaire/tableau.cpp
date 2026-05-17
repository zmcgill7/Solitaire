#include "tableau.h"
#include <QDebug>

tableau::tableau(QObject *parent)
    : QObject{parent}
{
    m_count = 0;
}

void tableau::receiveCard(QObject* cardObj)
{
    card* c = qobject_cast<card *>(cardObj);
    if(c)
    {
        m_cards.append(c);
        m_count++;
        emit cardsChanged();            // Notify that the cards have changed
        emit countChanged();
    }
    else
        qWarning() << "Failed to cast QObject to card* tableau::receiveCard";
}

bool tableau::isValid(QObject* cardObj)
{
    if (cardObj == nullptr) {
        qWarning() << "cardObj was null tableau::isValid";
        return false;
    }
    card* c = qobject_cast<card *>(cardObj);
    if(c)
    {
        if(m_count == 0)
        {
            if(c->getRank() == KING)
                return true;
            else
                return false;
        }
        else
        {
            if(c->getColor() != m_cards.last()->getColor()) //Card is different color
            {
                if(c->getRank() == m_cards.last()->getRank() - 1) //Could also done +1 to the card rank
                    return true;
                else
                    return false;
            }
            else //Trying to place a red on red or black on black
                return false;
        }
    }
    else
    {
        qWarning() << "Failed to cast QObject to card* tableau::isValid";
        return false;
    }

}

QList<QObject*> tableau::playCards(int index)
{
    QList<QObject*> tempCards;

    while(index < m_count)
    {
        card* c = m_cards.takeAt(index);
        //c->setParent(nullptr); // Detach from tableau
        if(c == nullptr)
            qWarning() << "Retruning a nullptr tableau::playCards()";
        tempCards.append(c);
        m_count--;
    }
    if(m_count != 0)
        m_cards.last()->setShowing(true);
    emit countChanged();
    emit cardsChanged();
    return tempCards;
}

void tableau::receiveCards(QList<QObject*> cardsObj)
{
    QList<card*> cards;
    for(auto obj : cardsObj)
    {
        cards.append(qobject_cast<card *>(obj));
    }
    m_cards.append(cards);
    m_count += cards.size();
    emit countChanged();
    emit cardsChanged();
}

bool tableau::isValidTableau(QList<QObject*> cardsObj)
{
    card* c = qobject_cast<card *>(cardsObj.first());
    if(c)
    {
        if(m_count == 0)
        {
            if(c->getRank() == KING)
                return true;
            else
                return false;
        }
        else
        {
            if(c->getColor() != m_cards.last()->getColor()) //Card is different color
            {
                if(c->getRank() == m_cards.last()->getRank() - 1) //Could also done +1 to the card rank
                    return true;
                else
                    return false;
            }
            else //Trying to place a red on red or black on black
                return false;
        }
    }
    else
    {
        qWarning() << "Failed to cast QObject to card* tableau::isValidTableau";
        return false;
    }
}

QList<QObject *> tableau::copyCards(int index)
{
    QList<QObject*> tempCards;

    while(index < m_count)
    {
        card* c = m_cards[index];
        //c->setParent(nullptr); // Detach from tableau
        tempCards.append(c);
        index++;
    }
    return tempCards;
}

QList<QObject*> tableau::getCards()
{
    QList<QObject*> cardList;
    for (card* card : m_cards) {
        cardList.append(card);
    }
    return cardList;
}

int tableau::getCount()
{
    return m_count;
}

void tableau::initializeTableau(QList<card *> &initialCards, int numCards)
{
    for(int i=0; i < numCards;i++)
    {
        m_cards.append(initialCards.takeLast());
        m_cards.last()->setShowing(false);
        m_count++;
    }
    m_cards[m_count - 1]->setShowing(true);
    emit cardsChanged();
    emit countChanged();
}

void tableau::clear()
{
    m_cards.clear();
    m_count = 0;
}

void tableau::deleteCards()
{
    for (card* c : m_cards) {
        delete c;  // Free the memory for each card object
    }
    m_cards.clear();
}

QList<bool> tableau::getIsShowings()
{
    QList<bool> myShowings;
    for(auto card: m_cards)
    {
        myShowings.append(card->getIsShowing());
    }
    return myShowings;
}

void tableau::flipCards(QList<bool> isShowings)
{
    for(int i=0; i<m_cards.size();i++)
    {
        card* card = m_cards[i];
        bool tempShowing = isShowings[i];
        if(card->getIsShowing() != tempShowing)
            card->setShowing(tempShowing);
    }
    emit cardsChanged();
}

tableau::~tableau()
{
    deleteCards();
}
