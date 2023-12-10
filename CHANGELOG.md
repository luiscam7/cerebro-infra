# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [0.3.0] - 2023-12-10

### Added
- Created VPC configuration, deployed AWS EMR serverless application.
- Readme

## [0.2.0] - 2023-12-09

### Added
- Added more terraform cli commands into make file.

### Removed
- Removed lambda, apigateway resources.

### Changed
- Build only one s3 bucket, give it enough permissions to load data.

## [0.1.0] - 2023-12-08

### Added
- Resource declarations for s3, lambda, apigateway, IAM.
- Makefile
- Changelog