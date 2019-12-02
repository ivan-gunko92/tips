// Кодировка utf-8.
#pragma once
#ifndef QUEUE_TS_H
#define QUEUE_TS_H

#include <queue>
#include <memory>
#include <mutex>

namespace sml {
    namespace basler {

        template<
            typename Item,
            typename Container = std::deque<Item>
        > 
        class Queue_ts {
        public:

            Queue_ts() = default;

            using SmartPtr = std::shared_ptr<Item>;

            void put(const Item& item);

            SmartPtr getSmartPtr();

            bool empty(bool lockAfterIfReturnFalse = false) const noexcept;

            Item get(bool wasLocked = false);

        private:

            using Mutex = std::mutex;

            mutable Mutex mutex_;
            std::queue<Item, Container> queue_;
        };

        template<
            typename Item,
            typename Container
        > 
        void Queue_ts<Item, Container>::put(const Item& item) {
            std::lock_guard<Mutex> lock(mutex_);
            queue_.push(item);
        }

        template<
            typename Item,
            typename Container
        > 
        bool Queue_ts<Item, Container>::empty(bool lockAfterIfFalse) const noexcept {
            std::lock_guard<Mutex> lock(mutex_);
            return queue_.empty();
        }

        template<
            typename Item,
            typename Container
        > 
        Item Queue_ts<Item, Container>::get(bool wasLocked) {
            std::lock_guard<Mutex> lock(mutex_);
            if (queue_.empty()) {
                throw std::logic_error("Trying to get element from empty queue");
            }
            auto firstItem = queue_.front();
            queue_.pop();
            return firstItem;
        }

        template<
            typename Item,
            typename Container
        > 
        typename Queue_ts<Item, Container>::SmartPtr Queue_ts<Item, Container>::getSmartPtr() {
            std::lock_guard<Mutex> lock(mutex_);
            if (queue_.empty()) {
                return nullptr;
            } else {
                auto firstItem = std::make_shared<Item>(queue_.front());
                queue_.pop();
                return firstItem;
            }
        }

    } //namespace basler
} //namespace sml

#endif //QUEUE_TS_H
