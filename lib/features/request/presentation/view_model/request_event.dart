import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart'; // For navigation events only
import 'dart:io'; // For file types in AddRequestEvent

abstract class RequestEvent extends Equatable {
  const RequestEvent();

  @override
  List<Object?> get props => [];
}

// Event to add a new request
class AddRequestEvent extends RequestEvent {
  final String description;
  final num neededAmount;
  final String condition;
  final String inDepthStory;
  final String citizen;
  final File supportingDoc;
  final File userImage;
  final File citizenshipImage;
  final BuildContext context; // For consistency with your Login example navigation

  const AddRequestEvent({
    required this.description,
    required this.neededAmount,
    required this.condition,
    required this.inDepthStory,
    required this.citizen,
    required this.supportingDoc,
    required this.userImage,
    required this.citizenshipImage,
    required this.context,
  });

  @override
  List<Object?> get props => [
        description,
        neededAmount,
        condition,
        inDepthStory,
        citizen,
        supportingDoc,
        userImage,
        citizenshipImage,
        context,
      ];
}

// Event to fetch all requests for the logged-in user
class GetMyRequestsEvent extends RequestEvent {}

// Event to delete a specific request by ID
class DeleteRequestEvent extends RequestEvent {
  final String requestId;
  final BuildContext context; // For consistency with your Login example navigation

  const DeleteRequestEvent({required this.requestId, required this.context});

  @override
  List<Object?> get props => [requestId, context];
}

// Event to navigate to the Add Request form
class NavigateToAddRequestEvent extends RequestEvent {
  final BuildContext context;

  const NavigateToAddRequestEvent({required this.context});

  @override
  List<Object?> get props => [context];
}

// Event to navigate back from the Add Request form
class NavigateBackFromAddRequestEvent extends RequestEvent {
  final BuildContext context;

  const NavigateBackFromAddRequestEvent({required this.context});

  @override
  List<Object?> get props => [context];
}