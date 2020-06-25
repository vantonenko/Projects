#pragma once

#include <iostream>

class ConsoleProgressBar {
private:
    int _goalItems;
    int _doneItems;
    int _percentage;
    int _step;
    int _length; // the length of the drawn progress bar

public:
    ConsoleProgressBar(int goalItems, int step = 1, int length = 50) : 
        _goalItems(goalItems), 
        _doneItems(0), 
        _percentage(0),
        _step(step),
        _length(length) { }
    
    void Draw() {
        std::string dashes(_percentage * _length / 100, '#');
        std::string spaces(_length - _percentage * _length / 100, '_');
        std::cout << "[" << dashes << spaces << "] (" << _percentage << "%)\r" << std::flush;

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