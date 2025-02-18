
classdef (CaseInsensitiveProperties=true) VAR ...
    < BaseVAR ...
    & matlab.mixin.CustomDisplay ...
    & iris.mixin.Plan

    properties
        G = [ ] % Coefficients at cointegrating vector in VEC form.

        % Sigma  Covariance matrix of parameter estimates
        Sigma = double.empty(0, 0, 0)

        % AIC  Akaike information criterion
        AIC = double.empty(1, 0)

        % AICc  Akaike information criterion corrected for small sample
        AICc = double.empty(1, 0)

        % SBC  Schwarz bayesian criterion
        SBC = double.empty(1, 0)

        Rr = [ ] % Parameter restrictions.
        NHyper = NaN % Number of estimated hyperparameters.
    end




    properties (Dependent)
        CovParameters
    end



    methods
        function out = getEndogenousForPlan(this)
            out = this.EndogenousNames;
        end%

        function out = getExogenousForPlan(this)
            out = this.ResidualNames;
        end%

        function out = getAutoswapsForPlan(this)
            out = string.empty(0, 2);
        end%

        function out = getSigmasForPlan(this)
            covShocks = getCovShocks(this);
            numY = this.NumEndogenous;
            numV = countVariants;
            out = nan(numY, 1, numV);
            for v = 1 : numV
                out(:, 1, v) = sqrt(diag(covShocks(:, :, v)));
            end
        end%
    end


    methods
        varargout = addToDatabank(varargin)
        varargout = assign(varargin)
        varargout = acf(varargin)
        varargout = backward(varargin)
        varargout = datarequest(varargin)
        varargout = demean(varargin)
        varargout = estimate(varargin)
        varargout = ferf(varargin)
        varargout = kalmaFilter(varargin)
        varargout = filter(varargin)
        varargout = fmse(varargin)
        varargout = forecast(varargin)
        varargout = forecast2(varargin)
        varargout = fprintf(varargin)
        varargout = get(varargin)
        varargout = group(varargin)
        varargout = infocrit(varargin)
        varargout = instrument(varargin)
        varargout = integrate(varargin)
        varargout = testCompatible(varargin)
        varargout = lrtest(varargin)
        varargout = mean(varargin)
        varargout = portest(varargin)
        varargout = resample(varargin)
        varargout = simulate(varargin)
        varargout = sprintf(varargin)
        varargout = sspace(varargin)
        varargout = vma(varargin)
        varargout = xasymptote(varargin)
        varargout = xsf(varargin)
        varargout = subsref(varargin)
        varargout = subsasgn(varargin)
    end


    methods (Hidden)
        varargout = hdatainit(varargin)
        varargout = end(varargin)
        varargout = saveobj(varargin)
        varargout = implementGet(varargin)
        varargout = SVAR(varargin)
        varargout = myresponse(varargin)
        varargout = size(varargin)
    end


    methods (Access=protected, Hidden)
        varargout = assignEst(varargin)
        varargout = getEstimationData(varargin)
        varargout = prepareLsqWeights(varargin)
        varargout = preallocate(varargin)
        varargout = myrngcmp(varargin);
        varargout = subsalt(varargin)
        varargout = specdisp(varargin)
        varargout = stackData(varargin)
    end


    methods (Static, Hidden)
        varargout = generalizedLsq(varargin)
        varargout = restrict(varargin)
        varargout = smoother(varargin)
    end


    methods
        function this = VAR(varargin)
% VAR  Create new empty reduced-form VAR object.
%{
% Syntax for Plain VAR and VAR with Exogenous Variables
%--------------------------------------------------------------------------
%
%     V = VAR(EndogenousNames)
%     V = VAR(EndogenousNames, "Exogenous", ExogenousNames)
%
%
% Syntax for Panel VAR and Panel VAR with Exogenous Variables
%--------------------------------------------------------------------------
%
%     V = VAR(EndogenousNames, "Groups", GroupNames)
%     V = VAR(EndogenousNames, "Exogenous", ExogenousNames, "Groups", GroupNames)
%
%
% Output Arguments
%--------------------------------------------------------------------------
%
% __`V`__ [ VAR ] –
%
%>    New empty VAR model object.
%
%
% __`EndogenousNames`__ [ string ]
%
%>    Names of endogenous variables.
%
%
% __`ExogenousNames`__ [ string ]
%
%>    Names of exogenous inputs.
%
%
% __`GroupNames`__ [ string ]
%
%>    Names of groups for panel VAR estimation.
%
%
% Options
%--------------------------------------------------------------------------
%
% __`Exogenous=[ ]` [ string ]
%
%>    Names of exogenous regressors; one of the names can be `!ttrend`, a
%>    linear time trend, which will be created automatically each time
%>    input data are required, and then included in the output database
%>    under the name `ttrend`.
%
%
% __`Groups=[ ]`__ [ string ]
%
%>    Names of groups for panel VAR estimation.
%
%
% __`Intercept=true`___ [ `true` | `false` ]
%
%>    Include the intercept in the VAR model.
%
%
% __`Order=1`__ [ numeric ]
%
%>    Order of the VAR model, i.e. the number of lags of endogenous
%>    variables included in estimation.
%
%
% Description
%--------------------------------------------------------------------------
%
% Create a new empty VAR object. The VAR constructor is usually
% followed by an [`estimate`](VAR/estimate) command to estimate
% the coefficient matrices in the VAR object using some data.
%
%
% Example
%--------------------------------------------------------------------------
%
% To estimate a VAR, first create an empty VAR object specifying the
% variable names, and then run the [VAR/estimate](VAR/estimate) function on
% it, e.g.
%
%     v = VAR(["x", "y", "z"]);
%     [v, d] = estimate(v, d, range);
%
% where the input database `d` is expected to include at least the time
% series `d.x`, `d.y`, `d.z`.
%
%}

% -[IrisToolbox] for Macroeconomic Modeling
% -Copyright (c) 2007-2022 [IrisToolbox] Solutions Team

%--------------------------------------------------------------------------

            this = this@BaseVAR(varargin{:});

            if nargin==0
                return
            elseif nargin==1 && isa(varargin{1}, 'VAR')
                this = varargin{1};
                return
            elseif nargin==1 && isstruct(varargin{1})
                this = struct2obj(this, varargin{1});
                return
            end
        end%
    end


    methods
        function value = get.CovParameters(this)
            value = this.Sigma;
        end%

        function value = getCovShocks(this)
            value = this.Omega;
        end%

        function value = getCovForecastErrors(this)
            value = this.Omega;
        end%
    end
end

