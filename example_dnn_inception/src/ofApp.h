//
// Copyright (c) 2017 Christopher Baker <https://christopherbaker.net>
//
// SPDX-License-Identifier:	MIT
//


#pragma once

//
// From http://dlib.net/dnn_inception_ex.cpp.html
//
// This is an example illustrating the use of the deep learning tools from the
// dlib C++ Library.  I'm assuming you have already read the introductory
// dnn_introduction_ex.cpp and dnn_introduction2_ex.cpp examples.  In this
// example we are going to show how to create inception networks.
//
// An inception network is composed of inception blocks of the form:
//
//       input from SUBNET
//      /        |        \
//     /         |         \
//    block1  block2  ... blockN
//     \         |         /
//      \        |        /
// concatenate tensors from blocks
//               |
//             output
//
// That is, an inception blocks runs a number of smaller networks (e.g. block1,
// block2) and then concatenates their results.  For further reading refer to:
// Szegedy, Christian, et al. "Going deeper with convolutions." Proceedings of
// the IEEE Conference on Computer Vision and Pattern Recognition. 2015.
//

#include "ofMain.h"
#include "ofxDlib.h"



// Inception layer has some different convolutions inside.  Here we define
// blocks as convolutions with different kernel size that we will use in
// inception layer block.
template <typename SUBNET>
using block_a1 = dlib::relu<dlib::con<10,1,1,1,1,SUBNET>>;

template <typename SUBNET>
using block_a2 = dlib::relu<dlib::con<10,3,3,1,1,dlib::relu<dlib::con<16,1,1,1,1,SUBNET>>>>;

template <typename SUBNET>
using block_a3 = dlib::relu<dlib::con<10,5,5,1,1,dlib::relu<dlib::con<16,1,1,1,1,SUBNET>>>>;

template <typename SUBNET>
using block_a4 = dlib::relu<dlib::con<10,1,1,1,1,dlib::max_pool<3,3,1,1,SUBNET>>>;


// Here is inception layer definition. It uses different blocks to process input
// and returns combined output.  Dlib includes a number of these inceptionN
// layer types which are themselves created using concat layers.
template <typename SUBNET>
using incept_a = dlib::inception4<block_a1,block_a2,block_a3,block_a4,SUBNET>;


// Network can have inception layers of different structure.  It will work
// properly so long as all the sub-blocks inside a particular inception block
// output tensors with the same number of rows and columns.
template <typename SUBNET>
using block_b1 = dlib::relu<dlib::con<4,1,1,1,1,SUBNET>>;

template <typename SUBNET>
using block_b2 = dlib::relu<dlib::con<4,3,3,1,1,SUBNET>>;

template <typename SUBNET>
using block_b3 = dlib::relu<dlib::con<4,1,1,1,1,dlib::max_pool<3,3,1,1,SUBNET>>>;

template <typename SUBNET>
using incept_b = dlib::inception3<block_b1,block_b2,block_b3,SUBNET>;

// Now we can define a simple network for classifying MNIST digits.  We will
// train and test this network in the code below.
using net_type = dlib::loss_multiclass_log<
dlib::fc<10,
dlib::relu<dlib::fc<32,
dlib::max_pool<2,2,2,2,incept_b<
dlib::max_pool<2,2,2,2,incept_a<
dlib::input<dlib::matrix<unsigned char>>
>>>>>>>>;


class ofApp: public ofBaseApp
{
public:
    void setup() override;

};
