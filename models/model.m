function varargout = model(varargin)
    m = 'minmaxratio';
    switch m
        case 'minmaxratio'
            [varargout{1:nargout}] = model_minmaxratio( varargin{:} );
        case 'gvalue'
            [varargout{1:nargout}] = model_gvalue( varargin{:} );
        case 'thresh'
            [varargout{1:nargout}] = model_thresh( varargin{:} );
        case 'hbm'
            [varargout{1:nargout}] = model_hbm( varargin{:} );
    end
end