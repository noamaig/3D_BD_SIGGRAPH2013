% Code implementing the paper "Injective and Bounded Mappings in 3D".
% Disclaimer: The code is provided as-is and without any guarantees. Please contact the author to report any bugs.
% Written by Noam Aigerman, http://www.wisdom.weizmann.ac.il/~noamaig/

%given an OPTIONS struct, displays a GUI for viewing the
%object and cross-cutting it
function cross_section_app(OPTIONS)
GUI_cross_section(OPTIONS,OPTIONS.PROBLEM.SOURCE_POS,OPTIONS.FINAL_POS,OPTIONS.PROBLEM.TRI,OPTIONS.FINAL_DISTORTION,OPTIONS.FINAL_FLIPS,OPTIONS.PROBLEM.CONSTRAINTS.ANCHOR_COORDS,OPTIONS.PROBLEM.CONSTRAINTS.STATIC_ANCHORS);
end
