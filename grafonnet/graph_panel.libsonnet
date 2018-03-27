local grafana = import "grafonnet/grafana.libsonnet";

{
    /**
     * Returns a new graph panel that can be added in a row.
     * It requires the graph panel plugin in grafana, which is built-in.
     *
     * @param title The title of the graph panel.
     * @param span Width of the panel
     * @param datasource Datasource
     * @param fill Fill, integer from 0 to 10
     * @param linewidth Line Width, integer from 0 to 10
     * @param decimals Override automatic decimal precision for legend and tooltip. If null, not added to the json output.
     * @param min_span Min span
     * @param format Unit of the Y axes
     * @param min Min of the Y axes
     * @param max Max of the Y axes
     * @param lines Display lines, boolean
     * @param points Display points, boolean
     * @param bars Display bars, boolean
     * @param dashes Display line as dashes
     * @param stack Stack values
     * @param repeat Variable used to repeat the graph panel
     * @param legend_show Show legend
     * @param legend_values Show values in legend
     * @param legend_min Show min in legend
     * @param legend_max Show max in legend
     * @param legend_current Show current in legend
     * @param legend_total Show total in legend
     * @param legend_avg Show average in legend
     * @param legend_alignAsTable Show legend as table
     * @param legend_rightSide Show legend to the right
     * @return A json that represents a graph panel
     */
    new(
        bars=false,
        dashes=false,
        datasource='$db',
        decimals=null,
        description=null,
        fill=1,
        format='short',
        gridPos={},
        height=null,
        legend_alignAsTable=true,
        legend_avg=true,
        legend_current=true,
        legend_hideEmpty=true,
        legend_hideZero=true,
        legend_max=true,
        legend_min=true,
        legend_rightSide=true,
        legend_show=true,
        legend_sideWidth=null,
        legend_total=false,
        legend_values=true,
        lines=true,
        linewidth=1,
        max=null,
        min=null,
        min_span=12,
        nullPointMode='null',
        points=false,
        repeat=null,
        repeatDirection=null,
        seriesOverrides=[],
        show_xaxis=true,
        sort='decreasing',
        span=12,
        stack=false,
        targets=[],
        title='',
        transparent=true,
    ):: {
        title: title,
        [if std.length(gridPos) == 0 then 'span']: span,
        [if min_span != null then 'minSpan']: min_span,
        [if gridPos != null then 'gridPos']: gridPos,
        type: 'graph',
        datasource: datasource,
        targets: targets,
        [if description != null then 'description']: description,
        [if height != null then 'height']: height,
        renderer: 'flot',
        transparent: transparent,
        yaxes: [
            self.yaxe(format, min, max, decimals=decimals),
            self.yaxe(format, min, max, decimals=decimals),
        ],
        xaxis: {
            show: show_xaxis,
            mode: 'time',
            name: null,
            values: [],
            buckets: null,
        },
        lines: lines,
        fill: fill,
        linewidth: linewidth,
        dashes: dashes,
        dashLength: 10,
        spaceLength: 10,
        points: points,
        pointradius: 5,
        bars: bars,
        stack: stack,
        percentage: false,
        legend: {
            show: legend_show,
            values: legend_values,
            min: legend_min,
            max: legend_max,
            current: legend_current,
            total: legend_total,
            alignAsTable: legend_alignAsTable,
            rightSide: legend_rightSide,
            avg: legend_avg,
            [if legend_hideEmpty != null then 'hideEmpty']: legend_hideEmpty,
            [if legend_hideZero != null then 'hideZero']: legend_hideZero,
            [if legend_sideWidth != null then 'sideWidth']: legend_sideWidth,
        },
        nullPointMode: nullPointMode,
        steppedLine: false,
        tooltip: {
            value_type: 'individual',
            shared: true,
            sort: if sort == 'decreasing' then 2 else if sort == 'increasing' then 1 else sort,
        },
        timeFrom: null,
        timeShift: null,
        aliasColors: {},
        repeat: repeat,
        [if repeatDirection != null then 'repeatDirection']: repeatDirection,
        seriesOverrides: seriesOverrides,
        thresholds: [],
        yaxe(
            format='short',
            min=null,
            max=null,
            label=null,
            show=true,
            logBase=1,
            decimals=null,
        ):: {
            label: label,
            show: show,
            logBase: logBase,
            min: min,
            max: max,
            format: format,
            [if decimals != null then 'decimals']: decimals,
        },
        _nextTarget:: 0,
        addTarget(target):: self {
            // automatically ref id in added targets.
            // https://github.com/kausalco/public/blob/master/klumps/grafana.libsonnet
            local nextTarget = super._nextTarget,
            _nextTarget: nextTarget + 1,
            targets+: [target { refId: std.char(std.codepoint('A') + nextTarget) }],
        },
        colorize(colors=grafana.outreach.colors):: self {
            aliasColors: {
                [self.targets[i].legendFormat]: colors[i % std.length(colors)]
                for i in std.range(0, std.length(self.targets) - 1)
            },
        },
    },
}
