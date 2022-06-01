# Simple Screens

[![license](http://img.shields.io/badge/license-CC0%201.0%20Universal-blue.svg)](https://github.com/moqui/SimpleScreens/blob/master/LICENSE.md)
[![build](https://travis-ci.org/moqui/SimpleScreens.svg)](https://travis-ci.org/moqui/SimpleScreens)
[![release](http://img.shields.io/github/release/moqui/SimpleScreens.svg)](https://github.com/moqui/SimpleScreens/releases)
[![commits since release](http://img.shields.io/github/commits-since/moqui/SimpleScreens/v2.2.0.svg)](https://github.com/moqui/SimpleScreens/commits/master)

[![Discourse Forum](https://img.shields.io/badge/moqui%20forum-discourse-blue.svg)](https://forum.moqui.org)
[![Google Group](https://img.shields.io/badge/google%20group-moqui-blue.svg)](https://groups.google.com/d/forum/moqui)
[![LinkedIn Group](https://img.shields.io/badge/linked%20in%20group-moqui-blue.svg)](https://www.linkedin.com/groups/4640689)
[![Stack Overflow](https://img.shields.io/badge/stack%20overflow-moqui-blue.svg)](http://stackoverflow.com/questions/tagged/moqui)

A library of simple screens and screen components (forms, sections, transitions) to be included, extended, or generally reused in applications based on Moqui Framework and Mantle Business Artifacts

To install simply put the SimpleScreens directory in the moqui/runtime/component or component-lib directory. To make sure SimpleScreens loads before your component add a dependency in your component's component.xml file like:

    <depends-on name="SimpleScreens"/>

Note that this component requires Mantle UDM and USL (mantle-udm, mantle-usl) to be in place and has component dependencies on them.
