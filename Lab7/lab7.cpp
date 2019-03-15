/*
 * CS 233 Spring 2018 Lab 7
 * Compile with: clang++ lab7.cpp -o lab7
 */

#include <bitset>
#include <iostream>
using namespace std;

// Canvas is a 10*32 bit array.
// unsigned int canvas[10] = {0};
// Origins is a 10*32 int array.
// unsigned int origins[32*10] = {0};

// Lab 7 part 1
// Set bit at a given location.
void add_dot(unsigned int pos, unsigned int* canvas) {
    unsigned int row = pos >> 5;
    unsigned int col = 31 - (pos & 31);
    canvas[row] |= (1 << col);
}

// Lab 7 part 2
// Given a map of origin values, return the origin of the query position.
unsigned int get_origin(unsigned int pos, unsigned int* origins) {
    while (pos != origins[pos]) {
        pos = origins[pos];
    }
    return pos;
}

// Add a horizontal or vertical line to the canvas and update the origin map.
void add_line(unsigned int start_pos, unsigned int end_pos,
              unsigned int* canvas, unsigned int* origins) {
    int step_size = 1;
    // Check if the line is vertical.
    if (!((start_pos ^ end_pos) & 31)) {
        step_size = 32;
    }
    if (start_pos > end_pos) {
        step_size *= -1;
    }
    // Update the origin map.
    add_dot(end_pos, canvas);
    for (int i = start_pos; i != end_pos; i += step_size) {
        add_dot(i, canvas);  // Implicitly cast a signed int to an unsigned int.
        origins[get_origin(i + step_size, origins)] = get_origin(i, origins);
    }
}

// Check whether two positions are connected by a set of lines.
bool is_connected(unsigned int pos1, unsigned int pos2,
                  unsigned int* origins) {
    return get_origin(pos1, origins) == get_origin(pos2, origins);
}

// Helper functions.
void init_origins(unsigned int* origins) {
    for (int i = 0; i < 32 * 10; i++) {
        origins[i] = i;
    }
}

void print_canvas(const unsigned int* canvas) {
    for (int i = 0; i < 10; i++) {
        cout << bitset<32>(canvas[i]) << endl;
    }
}

void print_origins(const unsigned int* origins) {
    for (int i = 0; i < 10; i++) {
        for (int j = 0; j < 32; j++) {
            if (origins[i * 32 + j] == i * 32 + j) {
                cout << ". ";
            } else {
                cout << origins[i * 32 + j] << " ";
            }
        }
        cout << endl;
    }
}

// Tests.
void test_add_dot() {
    unsigned int canvas[10] = {0};
    add_dot(0, canvas);
    add_dot(319, canvas);
    print_canvas(canvas);
}

void test_get_origins() {
    unsigned int origins[10*32] = {0};
    init_origins(origins);
    cout << get_origin(3, origins) << endl;
    // Simulate drawing two lines from 0 to 3 and from 3 to 99.
    for (int i = 0; i < 4; i++) {
        origins[3 + i * 32] = 0;
        origins[i] = 0;
    }
    print_origins(origins);
    cout << get_origin(0, origins) << endl;
    cout << get_origin(3, origins) << endl;
    cout << get_origin(99, origins) << endl;
}

void test_add_line() {
    unsigned int canvas[10] = {0};
    unsigned int origins[10*32] = {0};
    init_origins(origins);
    add_line(0, 3, canvas, origins);
    add_line(3, 99, canvas, origins);
    print_canvas(canvas);
    print_origins(origins);
}

void test_is_connected() {
    unsigned int origins[10*32] = {0};
    init_origins(origins);
    // Simulate drawing two lines from 0 to 3 and from 3 to 99.
    for (int i = 0; i < 4; i++) {
        origins[3 + i * 32] = 0;
        origins[i] = 0;
    }
    cout << is_connected(0, 99, origins) << endl;
    cout << is_connected(3, 99, origins) << endl;
    cout << is_connected(3, 4, origins) << endl;
}

int main() {
    test_add_dot();
    cout << "" << endl;
    test_get_origins();
    cout << "" << endl;
    test_is_connected();
    cout << "" << endl;
    test_add_line();
    return 0;
}
