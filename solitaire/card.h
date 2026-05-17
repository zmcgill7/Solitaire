#ifndef CARD_H
#define CARD_H

#include <QObject>

using namespace std;

enum cardSuit {
    DIAMOND,
    CLUB,
    HEART,
    SPADE,
    UNINITIALIZED = -1
};
const cardSuit suitList[4] = {DIAMOND, CLUB, HEART, SPADE};

enum cardColor {
    RED,
    BLACK
};

enum cardRank {
    ZERO = 0,
    ACE = 1,
    TWO,
    THREE,
    FOUR,
    FIVE,
    SIX,
    SEVEN,
    EIGHT,
    NINE,
    TEN,
    JACK,
    QUEEN,
    KING
};

const cardRank rankList[13] = {ACE, TWO, THREE, FOUR, FIVE, SIX, SEVEN, EIGHT, NINE, TEN, JACK, QUEEN, KING};

class card : public QObject {
    Q_OBJECT
    Q_PROPERTY(cardRank rank READ getRank WRITE setRank NOTIFY rankChanged)
    Q_PROPERTY(cardSuit suit READ getSuit WRITE setSuit NOTIFY suitChanged)
    Q_PROPERTY(cardColor color READ getColor NOTIFY colorChanged)
    Q_PROPERTY(QString imagePath READ getImagePath NOTIFY imagePathChanged)
    Q_PROPERTY(bool isShowing READ getIsShowing WRITE setShowing NOTIFY isShowingChanged)

public:
    explicit card(QObject *parent = nullptr); //Default constructor
    explicit card(cardRank rank, cardSuit suit, QString imagePath, QObject *parent = nullptr);

    cardRank getRank() const;
    cardSuit getSuit() const;
    cardColor getColor() const;
    QString getImagePath() const;
    bool getIsShowing() const;

    void setRank(cardRank rank);
    void setSuit(cardSuit suit);
    void setShowing(bool isShowing);
    ~card();

signals:
    void rankChanged();
    void suitChanged();
    void colorChanged();
    void imagePathChanged();
    void isShowingChanged();

private:
    cardRank rank;
    cardSuit suit;
    cardColor color;
    QString imagePath;
    bool isShowing = false;
};

#endif // CARD_H

