
classdef (Abstract) PlotMixin ...
    < matlab.mixin.Copyable

    properties (Hidden)
        Settings_ShowLegend (1, 1) logical = true
        Settings_LineWidth (1, 1) double {mustBeNonnegative} = 2
        Settings_LineDash (1, 1) string = "solid"
        Settings_Line (1, 1) struct = struct() % Low level
        Settings_Type (1, 1) string = "scatter"
        Settings_Mode (1, 1) string = ""
        Settings_Markers (1, 1) = struct()
        Settings_StackGroup (1, 1) string = ""
        Settings_Fill (1, 1) string = "none"
        Settings_Text (1, :) string = string.empty(1, 0)
        Settings_XZeroLine (1, 1) logical = false
        Settings_YZeroLine (1, 1) logical = false
    end


    methods
        function this = set.Settings_Markers(this, x)
            if isstruct(x)
                this.Settings_Markers = rephrase.lowerFields(x);
                if isfield(this.Settings_Markers, 'color')
                    this.Settings_Markers.color = ...
                        rephrase.ColorMixin.ensureRgbaArray(this.Settings_Markers.color);
                end
            elseif isequal(x, true)
                this.Settings_Markers = true;
            else
                this.Settings_Markers = NaN;
            end
        end%
    end
end
