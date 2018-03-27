local grafana = import 'grafonnet/grafana.libsonnet';

{
    datasource: {
        name: 'db',
        var: '$' + self.name,
        template(
            name=null,
            current=null,
        ):: (
            grafana.template.datasource(
                if name != null then name else $.datasource.name,
                'prometheus',
                if current != null then current else $.datasource.var,
            )
        ),
    },
    # jsonnet doesn't have variadic functions / **kwargs yet
    # and since we'll be creating targets *everywhere*
    # we want to be able to concisely make this call with an options hash
    # factoring out the default values into one authoritative object below
    # seemed like the most divergence-proof implementation available today
    local default = {
        target: {
            datasource: null,
            instant: null,
            intervalFactor: 10,
            interval: '15s',  # prometheus scrape interval
            legendFormat: '',
        },
    },
    target(
        expr,
        datasource=(default.target.datasource),
        instant=(default.target.instant),
        interval=(default.target.interval),
        intervalFactor=(default.target.intervalFactor),
        legendFormat=(default.target.legendFormat),
    ):: {
        [if datasource != null then 'datasource']: datasource,
        expr: expr,
        format: 'time_series',
        intervalFactor: intervalFactor,
        legendFormat: legendFormat,
        [if instant != null then 'instant']: instant,
        [if interval != null then 'interval']: interval,
    },
    targetFromObject(expr, opts={}):: (
        self.target(
            expr=expr,
            datasource=(if std.objectHas(opts, 'datasource') then opts.datasource else default.target.datasource),
            instant=(if std.objectHas(opts, 'instant') then opts.instant else default.target.instant),
            interval=(if std.objectHas(opts, 'interval') then opts.interval else default.target.interval),
            intervalFactor=(if std.objectHas(opts, 'intervalFactor') then opts.intervalFactor else default.target.intervalFactor),
            legendFormat=(if std.objectHas(opts, 'legendFormat') then opts.legendFormat else default.target.legendFormat),
        )
    ),
    targets(targets=[], opts={}):: (
        [self.targetFromObject(t[1], opts { legendFormat: t[0] }) for t in targets]
    ),
    template(
        name,
        query,
        allValues='.*',
        current='all',
        datasource=null,
        hide='',
        includeAll=true,
        label=null,
        multi=true,
        refresh=2,
        regex='',
        sort=1,
        tagsQuery='',
        tagValuesQuery='',
    ):: (
        grafana.template.new(
            name,
            if datasource != null then datasource else $.datasource.var,
            query,
            allValues=allValues,
            current=current,
            hide=hide,
            includeAll=includeAll,
            label=label,
            multi=multi,
            refresh=refresh,
            regex=regex,
            tagValuesQuery=tagValuesQuery,
        ) {
            sort: sort,
            tagsQuery: tagsQuery,
            useTags: tagsQuery != '',
        }
    ),
}
