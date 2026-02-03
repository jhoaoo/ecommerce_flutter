import '/flutter_flow/flutter_flow_count_controller.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/flutter_flow_widgets.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'test_model.dart';
export 'test_model.dart';

class TestWidget extends StatefulWidget {
  const TestWidget({super.key});

  @override
  State<TestWidget> createState() => _TestWidgetState();
}

class _TestWidgetState extends State<TestWidget> {
  late TestModel _model;

  @override
  void setState(VoidCallback callback) {
    super.setState(callback);
    _model.onUpdate();
  }

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => TestModel());
  }

  @override
  void dispose() {
    _model.maybeDispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional(0.81, 0.0),
      child: Container(
        width: 100.0,
        height: 100.0,

        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
        ),

        child: Stack(
          children: [
            Align(
              alignment: AlignmentDirectional(-0.01, -0.91),
              child: FlutterFlowIconButton(
                borderRadius: 8.0,

                buttonSize: 40.0,
                fillColor: Color(0x004E3F78),

                icon: FaIcon(
                  FontAwesomeIcons.trashAlt,
                  color: Colors.black,
                  size: 24.0,
                ),

                onPressed: () {
                  print('IconButton pressed ...');
                },
              ),
            ),
            Align(
              alignment: AlignmentDirectional(0.0, 0.49),
              child: Container(
                width: 120.0,
                height: 40.0,

                decoration: BoxDecoration(
                  color: FlutterFlowTheme.of(context).secondaryBackground,

                  borderRadius: BorderRadius.circular(8.0),
                  shape: BoxShape.rectangle,
                ),

                child: FlutterFlowCountController(
                  decrementIconBuilder: (enabled) => Icon(
                    Icons.remove_rounded,
                    color: enabled
                        ? FlutterFlowTheme.of(context).secondaryText
                        : FlutterFlowTheme.of(context).alternate,
                    size: 24.0,
                  ),
                  incrementIconBuilder: (enabled) => Icon(
                    Icons.add_rounded,
                    color: enabled
                        ? FlutterFlowTheme.of(context).primary
                        : FlutterFlowTheme.of(context).alternate,
                    size: 24.0,
                  ),
                  countBuilder: (count) => Text(
                    count.toString(),
                    style: FlutterFlowTheme.of(context).titleLarge.override(
                      font: GoogleFonts.interTight(
                        fontWeight: FlutterFlowTheme.of(
                          context,
                        ).titleLarge.fontWeight,
                        fontStyle: FlutterFlowTheme.of(
                          context,
                        ).titleLarge.fontStyle,
                      ),

                      letterSpacing: 0.0,
                      fontWeight: FlutterFlowTheme.of(
                        context,
                      ).titleLarge.fontWeight,
                      fontStyle: FlutterFlowTheme.of(
                        context,
                      ).titleLarge.fontStyle,
                    ),
                  ),
                  count: _model.countControllerValue ??= 0,
                  updateCount: (count) =>
                      safeSetState(() => _model.countControllerValue = count),
                  stepSize: 1,

                  contentPadding: EdgeInsetsDirectional.fromSTEB(
                    12.0,
                    0.0,
                    12.0,
                    0.0,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
