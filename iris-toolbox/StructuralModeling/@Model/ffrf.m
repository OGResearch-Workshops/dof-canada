%{
% 
% # `ffrf` ^^(Model)^^
% 
% {== Filter frequency response function of transition variables to measurement variables==}
% 
% 
% ## Syntax 
% 
%     [F, list] = ffrf(model, freq, ...)
% 
% 
%  ## Input Arguments
% 
%   __`model`__ [ Model ]
% >
% > Model object for which the frequency response function will be
% > computed.
% >
% 
%   __`freq`__ [ numeric ]
% >  
% > Vector of freq for which the response
% > function will be computed.
% >
% 
%  ## Output Arguments
% 
%   __`F`__ [ namedmat | numeric ]
% >  
% > Array with frequency responses of transition variables (in rows) to
% > measurement variables (in columns).
% >
% 
%   __`list`__ [ cell ]
% >  
% > List of transition variables in rows of the `F` matrix, and list of
% > measurement variables in columns of the `F` matrix.
% >
% 
% 
%  ## Options
% 
% 
%  __`Include=@all`__ [ char | cellstr | `@all` ]
% > 
% > Include the effect of the listed measurement variables only; `@all` means
% > all measurement variables.
% >
% 
%  __`Exclude=[ ]`__ [ char | cellstr | empty ]
% > 
% > Remove the effect of the
% > listed measurement variables.
% >
% 
%  __`MaxIter=500`__ [ numeric ]
% > 
% > Maximum number of iteration when
% > calculating a steady-state Kalman filter for zero-frequency FRF.
% >
% 
%  __`MatrixFormat='NamedMat'`__ [ `'NamedMat'` | `'Plain'` ]
% >
% > Return matrix
% > `F` as either a [`namedmat`](namedmat/Contents) object (i.e. matrix with
% > named rows and columns) or a plain numeric array.
% >
% 
%  __`Select=@all`__ [ `@all` | char | cellstr ]
% > 
% > Return FFRF for selected variables only; `@all` means all variables.
% >
% 
%  __`Tolerance=1e-7`__ [ numeric ]
% > 
% > Convergence tolerance when calculating a steady-state Kalman filter for
% > zero-frequency FRF.
% >
%  ## Description
% 
% 
%  ## Examples
% 
%}
% --8<--


function varargout = ffrf(this, freq, varargin)

persistent parser
if isempty(parser)
    parser = extend.InputParser('model.ffrf');
    parser.addRequired('model', @(x) isa(x, 'model'));
    parser.addRequired('freq', @isnumeric);
    parser.addParameter({'Include', 'Select'}, cell.empty(1, 0), @(x) isempty(x) || isequal(x, @all) || ischar(x) || isa(x, 'string') || iscellstr(x));
    parser.addParameter('Exclude', cell.empty(1, 0), @(x) isempty(x) || ischar(x) || isstring(x) || iscellstr(x));
    parser.addParameter('MatrixFormat', 'namedmat', @validate.matrixFormat);
    parser.addParameter('MaxIter', 500, @(x) isempty(x) || (isnumeric(x) && isscalar(x) && x>=0));
    parser.addParameter('Tolerance', 1e-7, @(x) isempty(x) || (isnumeric(x) && isscalar(x) && x>0));
    parser.addParameter('SystemProperty', false, @(x) isequal(x, false) || ((ischar(x) || isa(x, 'string') || iscellstr(x)) && ~isempty(x)));
end
opt = parse(parser, this, freq, varargin{:});
usingDefaults = parser.UsingDefaultsInStruct;

needsNamedMatrix = strcmpi(opt.MatrixFormat, 'namedmat');

%--------------------------------------------------------------------------

nv = length(this);
[ny, nxi] = sizeSolution(this.Vector);

assert( usingDefaults.Include || usingDefaults.Exclude, ...
        'model:ffrf:CannotCombineSelectExclude', ...
        'Options Select= and Exclude= cannot be combined.' );

inxY = this.Quantity.Type==1;
selectedNames = this.Quantity.Name(inxY);
if usingDefaults.Include && usingDefaults.Exclude
    % Neither Exclude= nor Select= (Include=)
    inxToInclude = true(1, ny);
else
    % Exclude= option
    if usingDefaults.Include
        inxToExclude = ismember(string(selectedNames), string(opt.Exclude));
        inxToInclude = ~inxToExclude;
    else
        % Select= (or Include=) option
        inxToInclude = ismember(string(selectedNames), string(opt.Include));
    end
end
solutionVectorX = printSolutionVector(this, 'x', @Behavior);
solutionVectorY = printSolutionVector(this, 'y', @Behavior);

% _System Property_
systemProperty = hereSetupSystemProperty( );
if ~isequal(opt.SystemProperty, false)
    varargout = { systemProperty };
    return
end

numFreq = numel(systemProperty.CallerData.Frequencies);
F = complex(nan(nxi, ny, numFreq, nv), nan(nxi, ny, numFreq, nv));


%==========================================================================
if ny>0 && any(inxToInclude)
    inxNaSolutions = reportNaNSolutions(this);
    for v = find(~inxNaSolutions)
        update(systemProperty, this, v);
        systemProperty.Function(this, systemProperty, v);
        F(:, :, :, v) = systemProperty.Outputs{1};
    end
end
%==========================================================================


% Convert output matrix to namedmat object if requested
if needsNamedMatrix
    F = NamedMatrix(F, solutionVectorX, solutionVectorY);
end
varargout = {F, {solutionVectorX, solutionVectorY}};

return


    function systemProperty = hereSetupSystemProperty( )
        systemProperty = SystemProperty(this);
        systemProperty.Function = @freqdom.ffrf3;
        systemProperty.MaxNumOfOutputs = 1;
        systemProperty.NamedReferences = {solutionVectorX, solutionVectorY};
        systemProperty.CallerData.IndexToInclude = inxToInclude;
        systemProperty.CallerData.MaxIter = opt.MaxIter;
        systemProperty.CallerData.Frequencies = freq(:)';
        systemProperty.CallerData.Tolerance = opt.Tolerance;
        if isequal(opt.SystemProperty, false)
            % Regular call
            systemProperty.OutputNames = { 'FF' };
        else
            % Prepare for SystemProperty calls
            systemProperty.OutputNames = opt.SystemProperty;
        end
        preallocateOutputs(systemProperty);
    end%
end%
