#pragma once

#include <iostream>

class ConsoleProgressBar {
private:
    int _goalItems;
    int _doneItems;
    int _percentage;
    int _step;

public:
    ConsoleProgressBar(int goalItems, int step = 1) : 
        _goalItems(goalItems), 
        _doneItems(0), 
        _percentage(0),
        _step(step) { }
    
    void Draw() {
        std::cout << _percentage << "%\r" << std::flush;

        if (_percentage > 99) {
            std::cout << std::endl;
        }
    }

    void ReportDoneItem() {
        int newPercentage = ++_doneItems * 100 / _goalItems;

        if (newPercentage > _percentage + _step - 1) {
            _percentage = newPercentage;
            Draw();
        }
    }
};