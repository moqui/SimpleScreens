# Simple Screens

[![license](http://img.shields.io/badge/license-CC0%201.0%20Universal-blue.svg)](https://github.com/moqui/SimpleScreens/blob/master/LICENSE.md)
[![build](https://travis-ci.org/moqui/SimpleScreens.svg)](https://travis-ci.org/moqui/SimpleScreens)
[![release](http://img.shields.io/github/release/moqui/SimpleScreens.svg)](https://github.com/moqui/SimpleScreens/releases)
[![commits since release](http://img.shields.io/github/commits-since/moqui/SimpleScreens/v1.0.0.svg)](https://github.com/moqui/SimpleScreens/commits/master)
[![downloads](http://img.shields.io/github/downloads/moqui/SimpleScreens/latest/total.svg)](https://github.com/moqui/SimpleScreens/releases)

A library of simple screens and screen components (forms, sections, transitions) to be included, extended, or generally reused in applications based on Moqui Framework and Mantle Business Artifacts

To install simply put the SimpleScreens directory in the moqui/runtime/component or component-lib directory. To make sure SimpleScreens loads before your component add a dependency in your component's component.xml file like:

    <depends-on name="SimpleScreens"/>

Note that this component requires Mantle Business Artifacts to be in place.
