#pragma once

#include <iostream>

class ConsoleProgressBar {
private:
    int _goalItems;
    int _doneItems;
    int _donePercentage;
    int _step;

public:
    ConsoleProgressBar(int goalItems, int step = 1) : 
        _goalItems(goalItems), 
        _doneItems(0), 
        _donePercentage(0),
        _step(step) { }
    
    void Draw() {
        std::cout << _donePercentage << "%" << std::endl;
    }

    void ReportDoneItem() {
        int newPercentage = ++_doneItems * 100 / _goalItems;

        if (newPercentage > _donePercentage + _step - 1) {
            _donePercentage = newPercentage;
            Draw();
        }
    }
};