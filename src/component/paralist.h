#ifndef PARALIST_H
#define PARALIST_H

#include <QObject>
#include <QVector>

struct ParaItem
{
    QString key;
    int value;
    QString unit;
};

class ParaList : public QObject
{
    Q_OBJECT
public:
    explicit ParaList(QObject *parent = nullptr);

    QVector<ParaItem> items() const;

    bool setItemAt(int index, const ParaItem &item);

signals:
    void preItemAppended();
    void postItemAppended();

    void preItemRemoved(int index);
    void postItemRemoved();

public slots:
    void appendItem(QString key, int value, QString unit);
    void removeItem(int index);

private:
    QVector<ParaItem> mItems;
};

#endif // PARALIST_H
