# Simple Screens

[![license](http://img.shields.io/badge/license-CC0%201.0%20Universal-blue.svg)](https://github.com/moqui/SimpleScreens/blob/master/LICENSE.md)

A library of simple screens and screen components (forms, sections, transitions) to be included, extended, or generally reused in applications based on Moqui Framework and Mantle Business Artifacts

To install simply put the SimpleScreens directory in the moqui/runtime/component or component-lib directory. To make sure SimpleScreens loads before your component add a dependency in your component's component.xml file like:

    <depends-on name="SimpleScreens"/>

Note that this component requires Mantle Business Artifacts to be in place.
