%% hw1.m
% Description: 给定速度场, 求轨迹
% Author: Guorui Wei (危国锐) (313017602@qq.com)
% Created at: Nov. 03, 2024
% Last modified: Nov. 05, 2024
%

clc; clear; close all;

if ~isfolder(".\fig\")
    mkdir(".\fig\");
end

%%

h = 15e3;
Params = [pi ./ (h * ones(1,3)), h, 2.25e9 / pi^2, 15];
flag_save = true;
fig_name = "fig_1_2_traj_1";
pos_init_list = {[0; 0; 100], [0; h/2; 100], [0; -h/2; 100]};
time_request = [0, 2.5e4];
hw1_2_unit(pos_init_list, time_request, Params, flag_save, fig_name);

flag_save = true;
fig_name = "fig_1_2_traj_2";
pos_init_list = {[0; 0; 100], [h/8; 0; 100], [-h/8; 0; 100]};
time_request = [0, 2.5e4];
hw1_2_unit(pos_init_list, time_request, Params, flag_save, fig_name);

%% function

function [] = hw1_2_unit(pos_init_list, time_request, Params, flag_save, fig_name)
    arguments
        pos_init_list = {[0; 0; 100], [7.5e3; 0; 100], [0; 7.5e3; 100], [-7.5e3; 0; 100], [0; -7.5e3; 100]};
        time_request = [0, 2e4];
        Params (1,6) = [pi ./ (15e3 * ones(1,3)), 15e3, 2.25e9 / pi^2, 15];
        flag_save = false;
        fig_name string = "fig_traj";
    end

    ode_solver = cell(size(pos_init_list));
    traj = ode_solver;
    % 求迹线 (trajectory)
    for pt_ind = 1:length(pos_init_list)
        pos_init = pos_init_list{pt_ind};
        ode_solver{pt_ind} = ode(ODEFcn=@velocity, InitialValue=pos_init, Parameters=Params, InitialTime=0);
        traj{pt_ind} = solve(ode_solver{pt_ind}, time_request(1), time_request(2));
    end

    % 绘图
    t_fig = figure(Name=fig_name);

    % set figure size
    UNIT_ORIGINAL = t_fig.Units;
    t_fig.Units = "centimeters";
    t_fig.Position = [3, 3, 16, 16];
    t_fig.Units = UNIT_ORIGINAL;

    % plot
    t_TCL = tiledlayout(t_fig, 2, 2, TileSpacing="compact", Padding="compact");

    % 主视图
    t_axes = nexttile(t_TCL, 1);
    hold(t_axes, "on");
    for pt_ind = 1:length(pos_init_list)
        plot(t_axes, traj{pt_ind}.Solution(1,:) / Params(4), traj{pt_ind}.Solution(3,:) / Params(4), '-o', LineWidth=0.8, MarkerIndices=1, ...
            DisplayName=sprintf("$[%s]$", join(string(pos_init_list{pt_ind}), ",")));
    end
    hold(t_axes, "off");
    set(t_axes, FontName="Times New Roman", FontSize=10.5, Box="on", TickLabelInterpreter="latex", ...
        Tag="(a)");
    xlabel(t_axes, "$x$ $(h)$", Interpreter="latex", FontSize=10.5);
    ylabel(t_axes, "$z$ $(h)$", Interpreter="latex", FontSize=10.5);

    % 左视图
    t_axes = nexttile(t_TCL, 2);
    hold(t_axes, "on");
    for pt_ind = 1:length(pos_init_list)
        plot(t_axes, traj{pt_ind}.Solution(2,:) / Params(4), traj{pt_ind}.Solution(3,:) / Params(4), '-o', LineWidth=0.8, MarkerIndices=1, ...
            DisplayName=sprintf("$[%s]$", join(string(pos_init_list{pt_ind}), ",")));
    end
    hold(t_axes, "off");
    set(t_axes, FontName="Times New Roman", FontSize=10.5, Box="on", TickLabelInterpreter="latex", XDir="reverse", ...
        Tag="(b)");
    xlabel(t_axes, "$y$ $(h)$", Interpreter="latex", FontSize=10.5);
    ylabel(t_axes, "$z$ $(h)$", Interpreter="latex", FontSize=10.5);

    % 俯视图
    t_axes = nexttile(t_TCL, 3);
    hold(t_axes, "on");
    for pt_ind = 1:length(pos_init_list)
        plot(t_axes, traj{pt_ind}.Solution(1,:) / Params(4), traj{pt_ind}.Solution(2,:) / Params(4), '-o', LineWidth=0.8, MarkerIndices=1, ...
            DisplayName=sprintf("$[%s]$", join(string(pos_init_list{pt_ind}), ",")));
    end
    hold(t_axes, "off");
    set(t_axes, FontName="Times New Roman", FontSize=10.5, Box="on", TickLabelInterpreter="latex", ...
        Tag="(c)");
    xlabel(t_axes, "$x$ $(h)$", Interpreter="latex", FontSize=10.5);
    ylabel(t_axes, "$y$ $(h)$", Interpreter="latex", FontSize=10.5);

    % 立体图
    t_axes = nexttile(t_TCL, 4);
    for pt_ind = 1:length(pos_init_list)
        plot3(t_axes, traj{pt_ind}.Solution(1,:) / Params(4), traj{pt_ind}.Solution(2,:) / Params(4), traj{pt_ind}.Solution(3,:) / Params(4), '-o', LineWidth=0.8, MarkerIndices=1, ...
            DisplayName=sprintf("$[%s]$", join(string(pos_init_list{pt_ind}), ",")));
        hold(t_axes, "on");
    end
    hold(t_axes, "off");
    set(t_axes, FontName="Times New Roman", FontSize=10.5, Box="on", TickLabelInterpreter="latex", ...
        Tag="(d)");
    xlabel(t_axes, "$x$ $(h)$", Interpreter="latex", FontSize=10.5);
    ylabel(t_axes, "$y$ $(h)$", Interpreter="latex", FontSize=10.5);
    zlabel(t_axes, "$z$ $(h)$", Interpreter="latex", FontSize=10.5);

    % 绘图细节
    linkaxes([nexttile(t_TCL, 1), nexttile(t_TCL, 3)], 'x');
    linkaxes([nexttile(t_TCL, 1), nexttile(t_TCL, 2)], 'y');

    t_axes_b = nexttile(t_TCL, 2);
    t_axes_c = nexttile(t_TCL, 3);
    y_lim = [t_axes_b.XLim, t_axes_c.YLim];
    y_lim = [min(y_lim), max(y_lim)];
    t_axes_b.XLim = y_lim;
    t_axes_c.YLim = y_lim;

    for t_axes = findobj(t_TCL, 'Type', "Axes", {'-regexp', 'Tag', "^\([a-z]+\)"}).'
        t_txt_box = annotation(t_fig, "textbox", String="\bf " + t_axes.Tag, Position=[t_axes.Position([1, 2]) + [0, t_axes.Position(4)], .1, .1], FontSize=10.5, Interpreter="latex", LineStyle="none", HorizontalAlignment="left", VerticalAlignment="top");
        UNIT_ORIGINAL = t_txt_box.Units;
        t_txt_box.Units = "points";
        t_txt_box.Position = [t_txt_box.Position([1,2]) - [0, 10.5*1.5], 10.5*10, 10.5*1.5];
        t_txt_box.Units = UNIT_ORIGINAL;
    end

    if flag_save
        print(t_fig, ".\fig\" + t_fig.Name + ".svg", "-vector", "-dsvg")
    end

    %%% 立体图

    t_fig = figure(Name=fig_name+"_3D");

    % set figure size
    UNIT_ORIGINAL = t_fig.Units;
    t_fig.Units = "centimeters";
    t_fig.Position = [3, 3, 16, 16];
    t_fig.Units = UNIT_ORIGINAL;

    % plot
    t_TCL = tiledlayout(t_fig, 1, 1, TileSpacing="compact", Padding="compact");
    title(t_TCL,{"$r'(r, t) = M (\sin{\varphi}, \cos{\varphi}, 0) + \nabla_{\mathrm{H}} S_z - e_3 \times \kappa \nabla_{\mathrm{H}} S + e_3 \kappa_{\mathrm{H}}^2 S, \quad$ " + compose("$t:$ %.2g $\\to$ %.2e", time_request); "$r := (x, y, z), \; \varphi := \kappa (z - h / 2), \; S = S_0 \cos{(kx)} \cos{(ly)} \sin{(mz)}$"}, FontSize=10.5, Interpreter="latex");
    t_axes = nexttile(t_TCL, 1);
    for pt_ind = 1:length(pos_init_list)
        plot3(t_axes, traj{pt_ind}.Solution(1,:) / Params(4), traj{pt_ind}.Solution(2,:) / Params(4), traj{pt_ind}.Solution(3,:) / Params(4), '-o', LineWidth=0.8, MarkerIndices=1, ...
            DisplayName=compose("(%s) [%.3g, %.3g, %.2e]", ode_solver{pt_ind}.SelectedSolver, pos_init_list{pt_ind}.' / Params(4)));
        hold(t_axes, "on");
    end
    hold(t_axes, "off");
    set(t_axes, FontName="Times New Roman", FontSize=10.5, Box="on", TickLabelInterpreter="latex", ...
        Tag="(d)");
    xlabel(t_axes, "$x$ $(h)$", Interpreter="latex", FontSize=10.5);
    ylabel(t_axes, "$y$ $(h)$", Interpreter="latex", FontSize=10.5);
    zlabel(t_axes, "$z$ $(h)$", Interpreter="latex", FontSize=10.5);

    legend(t_axes, Location="northwest", Interpreter="latex", FontSize=10.5, Box="off", NumColumns=1);
    % lgd.Layout.Tile = "east";

    if flag_save
        print(t_fig, ".\fig\" + t_fig.Name + ".svg", "-vector", "-dsvg")
    end
end

function drdt = velocity(t, r, P)
arguments
    t = 0;
    r (3,1) = [0; 0; 0]
    P (1,6) = [pi ./ (15e3 * ones(1,3)), 15e3, 2.25e9 / pi^2, 15];
end
    wave_vec = P(1:3);
    h = P(4);
    S_0 = P(5);
    M = P(6);

    kappa_H = sqrt(sum(wave_vec(1:2).^2));
    kappa = sqrt(sum(wave_vec.^2));

    S = @(r) S_0 * cos(wave_vec(1)*r(1)) * cos(wave_vec(2)*r(2)) * sin(wave_vec(3)*r(3));
    S_z = @(r) S_0 * (+ wave_vec(3)) * cos(wave_vec(1)*r(1)) * cos(wave_vec(2)*r(2)) * cos(wave_vec(3)*r(3));
    S_x = @(r) S_0 * (- wave_vec(1)) * sin(wave_vec(1)*r(1)) * cos(wave_vec(2)*r(2)) * sin(wave_vec(3)*r(3));
    S_y = @(r) S_0 * (- wave_vec(2)) * cos(wave_vec(1)*r(1)) * sin(wave_vec(2)*r(2)) * sin(wave_vec(3)*r(3));
    S_zx = @(r) S_0 * (- wave_vec(1) * wave_vec(3)) * sin(wave_vec(1)*r(1)) * cos(wave_vec(2)*r(2)) * cos(wave_vec(3)*r(3));
    S_zy = @(r) S_0 * (- wave_vec(2) * wave_vec(3)) * cos(wave_vec(1)*r(1)) * sin(wave_vec(2)*r(2)) * cos(wave_vec(3)*r(3));

    drdt = zeros(3,1);

    drdt(1) = M*sin(kappa * (r(3) - h/2)) + kappa * S_y(r) + S_zx(r);
    drdt(2) = M*cos(kappa * (r(3) - h/2)) - kappa * S_x(r) + S_zy(r);
    drdt(3) = kappa_H^2 * S(r);
end
