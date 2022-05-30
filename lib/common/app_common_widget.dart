/*
 *  Copyright (C), 2015-2021
 *  FileName: app_common_widget
 *  Author: Tonight丶相拥
 *  Date: 2021/7/16
 *  Description: 
 **/

library appcommon;


/// 插件导入
import 'package:extended_image/extended_image.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:hjnzb/http/http_channel.dart';
import 'package:hjnzb/app_images/app_images.dart';
import 'package:hjnzb/i18n/i18n.dart';
import 'dart:async';
import 'dart:typed_data';
import 'package:get_storage/get_storage.dart';
import 'dart:io';
// import 'package:get/get.dart' as g;

/// 系统导入
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/cupertino.dart';
import 'package:uuid/uuid.dart';

import '../config/app_colors.dart';

/// 包含文件
part 'event_bus/event_bus.dart';
part 'common_widget/data_empty/data_empty.dart';
part 'common_widget/bar_pulse_loading/bar_pulse_loading.dart';
part 'common_widget/screen_util_custom.dart';
part 'common_widget/appbar/appbar.dart';
part 'common_widget/appbar/back_button.dart';
part 'common_widget/web_verify_code/web_verify_code.dart';
part 'common_widget/appbar/default_appbar.dart';
part 'common_widget/refresh_widget/refresh_widget.dart';
part 'common_widget/tabbar_decoration/tabbar.dart';
part 'common_widget/tabbar_decoration/tabbar_decoration.dart';
part 'common_widget/tabbar_decoration/tabbar_linear_gradient_decoration.dart';
part 'common_widget/bottom_navigation_item.dart';
part 'common_widget/table_row_margin/table_row_margin.dart';
part 'common_widget/custom_divider/custom_divider.dart';
part 'common_widget/null_widget/null_widget.dart';
part 'common_widget/ink_well_row/ink_well_row.dart';
part 'common_widget/tabbar_decoration/eliminate_font_animation_tabbar.dart';
part 'common_widget/switch_widget/switch_widget.dart';
part 'common_widget/dashed_decoration/dashed_decoration.dart';
part 'common_widget/dot_border/dot_border.dart';
part 'common_widget/custom_textfiled/custom_textfield.dart';
part 'common_widget/custom_textfiled/message_input.dart';
part 'common_widget/custom_textfiled/text_input_formatter.dart';
part 'common_widget/custom_textfiled/regex_set.dart';
part 'common_widget/consulting_warning/consulting_worning.dart';
part 'common_widget/constrains_expand_widget/constrains_expand_widget.dart';
part 'common_widget/loading_widget/loading_widget.dart';
part 'common_widget/slide_button/slide_button.dart';
part 'common_widget/function_list/function_list.dart';
part 'common_widget/function_list/sliver_action_list.dart';
part 'common_widget/function_list/sort_list/sort_list.dart';
part 'common_widget/animated_padding_textfiled/animated_padding_textfiled.dart';
part 'common_widget/dots_indicator/dots_indicator.dart';
part 'common_widget/visible_when_Focused/visible_when_focused.dart';
part 'common_widget/custom_show_modal_bottom_sheet/custom_show_modal_bottom_sheet.dart';
part 'common_widget/expanded_viewport/expanded_viewport.dart';
part 'common_widget/conversation_scoll_view/conversation_scroll_view.dart';
part 'common_widget/refresh_widget/conversation_refresh_widget.dart';
part 'common_widget/custom_text/custom_text.dart';
part 'common_widget/background_tabbar/background_tabbar.dart';
part 'common_widget/top_triangle_border/top_triangle_border.dart';
part 'common_widget/process_mask_widget/process_mask_widget.dart';
part 'common_widget/upload_widget/upload_widget.dart';
part 'common_widget/custom_selector/custom_selector.dart';
part 'common_widget/widget_extension.dart';
part 'common_widget/line_progress/line_progress.dart';
part 'common_widget/half_circle_process/half_circle_process.dart';
part 'common_widget/gradient_border/gradient_border.dart';
part 'common_widget/interval_button/interval_button.dart';
part 'common_widget/custom_tabbar_view/custom_tabbar_view.dart';
part 'common_widget/custom_drop_down_button/custom_drop_down_button.dart';
part 'common_widget/giftView/custom_gift_view.dart';
part 'widget_extension.dart';