#include "card.h"
#include <QDebug>

card::card(QObject *parent)
{
}

card::card(cardRank rank, cardSuit suit, QString imagePath, QObject *parent) // Constructor for a card
    : QObject(parent), rank(rank), suit(suit) {

    if (suit == DIAMOND || suit == HEART) {
        this->color = RED;
    } else {
        this->color = BLACK;
    }

    this->rank = rank;
    this->suit = suit;
    this->imagePath = imagePath;
}

cardRank card::getRank() const {
    return rank;
}

cardSuit card::getSuit() const {
    return suit;
}

cardColor card::getColor() const {
    return color;
}

QString card::getImagePath() const {
    if(isShowing)
        return imagePath;
    else
        return "images/blueCardBack.svg";
}

bool card::getIsShowing() const {
    return this->isShowing;
}

void card::setRank(cardRank rank) {
    if (this->rank != rank) {
        this->rank = rank;
        emit rankChanged();  // Emit signal for QML
    }
}

void card::setSuit(cardSuit suit) {
    if (this->suit != suit) {
        this->suit = suit;
        emit suitChanged();  // Emit signal for QML
    }
}

void card::setShowing(bool boolInput) {
    if (this->isShowing != boolInput) {
        this->isShowing = boolInput;
        emit isShowingChanged();  // Emit signal for QML
    }
}

card::~card() {
    //qDebug() << "Card destroyed:" << this << "Value:" << this->rank << "Suit:" << this->suit;
}
