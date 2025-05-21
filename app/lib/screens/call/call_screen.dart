import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';
import 'package:medicall/screens/call/bloc/call_bloc.dart';
import 'package:livekit_client/livekit_client.dart';

class CallScreen extends StatelessWidget {
  const CallScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Call Screen'),
      ),
      body: BlocProvider(
        create: (context) => CallBloc(),
        child: BlocBuilder<CallBloc, CallState>(
          builder: (context, state) => DisplayAppropriateScreen(state: state),
        ),
      ),
    );
  }
}

class DisplayAppropriateScreen extends StatelessWidget {
  const DisplayAppropriateScreen({required this.state, super.key});
  final CallState state;

  @override
  Widget build(BuildContext context) {
    void callStart() {
      context
          .read<CallBloc>()
          .add(CallStartEvent('IDFORANOTHERUSERORSOMETHING'));
    }

    void callCancel() {
      context.read<CallBloc>().add(CallCancelEvent());
    }

    if (state is CallInitial) {
      return CallInitialUI(callStart: callStart);
    } else if (state is CallCalling) {
      return CallCallingUI(callCancel: callCancel);
    } else if (state is CallAnswered) {
      final answered = state as CallAnswered;
      return CallAnsweredUI(
        localParticipant: answered.localParticipant,
        remoteParticipants: answered.remoteParticipants,
        callCancel: callCancel,
      );
    } else if (state is CallError) {
      final error = state as CallError;
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(error.msg),
            CallInitialUI(callStart: callStart),
          ],
        ),
      );
    } else {
      return const Center(child: Text('Unknown State'));
    }
  }
}

class CallInitialUI extends StatelessWidget {
  const CallInitialUI({required this.callStart, super.key});
  final VoidCallback callStart;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: callStart,
        child: const Text('Start Call'),
      ),
    );
  }
}

class CallCallingUI extends StatelessWidget {
  const CallCallingUI({required this.callCancel, super.key});
  final VoidCallback callCancel;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(),
          const SizedBox(height: 16),
          const Text('Calling...'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: callCancel,
            child: const Text('Cancel Call'),
          ),
        ],
      ),
    );
  }
}

class CallAnsweredUI extends StatelessWidget {
  const CallAnsweredUI({
    required this.localParticipant,
    required this.remoteParticipants,
    required this.callCancel,
    super.key,
  });
  final Participant localParticipant;
  final List<Participant> remoteParticipants;
  final VoidCallback callCancel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              if (remoteParticipants.isEmpty) {
                return ParticipantsGrid(
                  participants: [localParticipant],
                  constraints: constraints,
                );
              }

              return Stack(
                children: [
                  ParticipantsGrid(
                    participants: remoteParticipants,
                    constraints: constraints,
                  ),
                  if (localParticipant.hasVideo)
                    HoveringVideo(
                      participant: localParticipant,
                      constraints: constraints,
                    ),
                ],
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 25),
          child: ElevatedButton(
            onPressed: callCancel,
            child: const Text('Cancel Call'),
          ),
        ),
      ],
    );
  }
}

class ParticipantsGrid extends StatelessWidget {
  const ParticipantsGrid({
    required this.participants,
    required this.constraints,
    super.key,
  });
  final List<Participant> participants;
  final BoxConstraints constraints;

  @override
  Widget build(BuildContext context) {
    final columns =
        participants.length >= 9 ? 3 : (participants.length >= 4 ? 2 : 1);
    final rows = (participants.length / columns).ceil();
    final itemHeight = constraints.maxHeight / rows;
    return GridView.builder(
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: columns,
        mainAxisExtent: itemHeight,
      ),
      itemCount: participants.length,
      itemBuilder: (context, index) =>
          ParticipantBlock(participant: participants[index]),
    );
  }
}

class HoveringVideo extends StatefulWidget {
  const HoveringVideo({
    required this.participant,
    required this.constraints,
    super.key,
  });

  final Participant participant;
  final BoxConstraints constraints;

  @override
  State<HoveringVideo> createState() => _HoveringVideoState();
}

class _HoveringVideoState extends State<HoveringVideo> {
  // Default alignment for the draggable block
  Alignment _smallBlockAlignment = Alignment.bottomRight;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // Big video (first participant)
        // Small video (second participant), if exists
        // Four draggable targets in the corners
        ...[
          Alignment.topLeft,
          Alignment.topRight,
          Alignment.bottomLeft,
          Alignment.bottomRight,
        ].map(
          (a) => DragCornerTarget(
            alignment: a,
            constraints: widget.constraints,
            onAccept: (a) {
              setState(() {
                _smallBlockAlignment = a;
              });
            },
          ),
        ),

        Align(
          alignment: _smallBlockAlignment,
          child: Builder(
            builder: (context) {
              final video = SizedBox(
                width: widget.constraints.maxWidth * 0.3,
                height: widget.constraints.maxHeight * 0.25,
                child: ParticipantBlock(
                  participant: widget.participant,
                ),
              );
              return Draggable<int>(
                data: 1,
                feedback: video,
                childWhenDragging: const SizedBox.shrink(),
                child: video,
              );
            },
          ),
        ),
      ],
    );
  }
}

class DragCornerTarget extends StatelessWidget {
  const DragCornerTarget({
    required this.alignment,
    required this.constraints,
    required this.onAccept,
    super.key,
  });
  final Alignment alignment;
  final BoxConstraints constraints;
  final void Function(Alignment) onAccept;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: alignment,
      child: DragTarget<int>(
        builder: (context, candidateData, rejectedData) {
          return SizedBox(
            width: constraints.maxWidth / 2,
            height: constraints.maxHeight / 2,
          );
        },
        onWillAcceptWithDetails: (data) => true,
        onAcceptWithDetails: (data) {
          onAccept(alignment);
        },
      ),
    );
  }
}

class ParticipantBlock extends StatelessWidget {
  const ParticipantBlock({required this.participant, super.key});
  final Participant participant;

  @override
  Widget build(BuildContext context) {
    const colors = [
      Colors.pink,
      Colors.blue,
      Colors.amber,
      Colors.deepPurpleAccent,
      Colors.green,
      Colors.red,
      Colors.teal,
      Colors.orange,
    ];

    final videos = participant.videoTrackPublications
        .where((v) => v.track != null)
        .map((v) => v.track! as VideoTrack)
        .toList();

    Widget display = ColoredBox(
      color: colors[participant.identity.hashCode % colors.length],
      child: Center(child: Text(participant.name)),
    );

    if (videos.isNotEmpty) {
      display = VideoTrackRenderer(
        videos.first,
        fit: RTCVideoViewObjectFit.RTCVideoViewObjectFitCover,
      );
    }

    // Use Stack to overlay the border and avoid the gap
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: display,
        ),
        Positioned.fill(
          child: IgnorePointer(
            child: Container(
              decoration: BoxDecoration(
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
