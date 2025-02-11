DROP DATABASE IF EXISTS automl;
CREATE DATABASE `automl`;

USE `automl`;

/**
数据集表:
id, name, description, namespace, uri, createTime, createId, updateTime, updateId
 */
CREATE TABLE `ml_dataset`
(
    `id`           bigint(20) unsigned AUTO_INCREMENT NOT NULL COMMENT 'id',
    `name`         varchar(200)                       NOT NULL DEFAULT '' COMMENT '名称',
    `description`  text                               NOT NULL COMMENT '描述',
    `namespace_id` bigint(20)                         NOT NULL DEFAULT '0' COMMENT '命名空间id',
    `uri`          varchar(500)                       NOT NULL DEFAULT '' COMMENT '存储链接',
    `create_id`    bigint(20)                         NOT NULL DEFAULT '0' COMMENT '创建者',
    `create_time`  bigint(20)                         NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_id`    bigint(20)                         NOT NULL DEFAULT '0' COMMENT '修改者',
    `update_time`  bigint(20)                         NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT = '数据集表';

/**
命令空间表
id, name, description, owner_id, create_id, update_id
 */
CREATE TABLE `ml_namespace`
(
    `id`          bigint(20) unsigned AUTO_INCREMENT NOT NULL COMMENT 'id',
    `name`        varchar(200)                       NOT NULL DEFAULT '' COMMENT '名称',
    `description` text                               NOT NULL COMMENT '描述',
    `owner_id`    bigint(20)                         NOT NULL DEFAULT '0' COMMENT '所有者',
    `create_id`   bigint(20)                         NOT NULL DEFAULT '0' COMMENT '创建者',
    `create_time` bigint(20)                         NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_id`   bigint(20)                         NOT NULL DEFAULT '0' COMMENT '修改者',
    `update_time` bigint(20)                         NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT = '命名空间表';


/**
用户表:
id, name, admin, roles(json [1,2,3]), groups(json [1,2,3]), pending(没有明白..)
auth_state(long ms)
admin, role 合成一个吧
role 代表角色, 比如平台角色(普通用户, 超管), 数据角色(数据操作能力, 新增,删除,修改等等)
groups
 */
CREATE TABLE `ml_user`
(
    `id`   bigint(20) unsigned AUTO_INCREMENT NOT NULL COMMENT '用户id',
    `name` varchar(200)                       NOT NULL DEFAULT '' COMMENT '用户名称',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT = '用户表';

CREATE TABLE `ml_role`
(
    `id`          bigint(20) unsigned AUTO_INCREMENT NOT NULL COMMENT '用户id',
    `name`        varchar(200)                       NOT NULL DEFAULT '' COMMENT '角色名称',
    `description` text                               NOT NULL COMMENT '描述',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT = '角色表';

CREATE TABLE `ml_group`
(
    `id`          bigint(20) unsigned AUTO_INCREMENT NOT NULL COMMENT '分组id',
    `name`        varchar(200)                       NOT NULL DEFAULT '' COMMENT '分组名称',
    `description` text                               NOT NULL COMMENT '描述',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT = '分组表';

/**
其实就是用户角色分组表.
 */
CREATE TABLE `ml_user_role_group`
(
    `id`          bigint(20) unsigned AUTO_INCREMENT NOT NULL COMMENT 'id',
    `user_id`     bigint(20) unsigned                NOT NULL DEFAULT '0' COMMENT '用户id',
    `role_id`     bigint(20) unsigned                NOT NULL DEFAULT '0' COMMENT '角色id',
    `group_id`    bigint(20) unsigned                NOT NULL DEFAULT '0' COMMENT '分组id',
    `auto_time`   bigint(20) unsigned                NOT NULL DEFAULT '0' COMMENT '授权时间',
    `create_id`   bigint(20)                         NOT NULL DEFAULT '0' COMMENT '创建者',
    `create_time` bigint(20)                         NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_id`   bigint(20)                         NOT NULL DEFAULT '0' COMMENT '修改者',
    `update_time` bigint(20)                         NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`),
    UNIQUE KEY `idx_group_role_user` (`group_id`, `role_id`, `user_id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT = '用户角色分组表';


/**
version
 */
CREATE TABLE `ml_model_version`
(
    `id`           bigint(20) unsigned AUTO_INCREMENT NOT NULL COMMENT 'id',
    `name`         varchar(200)                       NOT NULL DEFAULT '' COMMENT '版本名称',
    `display_name` varchar(200)                       NOT NULL DEFAULT '' COMMENT '版本外显名称',
    `description`  text                               NOT NULL COMMENT '描述信息',
    `error_msg`    text                               NOT NULL COMMENT '异常信息',
    `state`        int(10) unsigned                   NOT NULL COMMENT '状态 0: 未指定, 1:准备好了(可以预测), 2:训练中, 100:失败',
    `meta_id`      bigint(20)                         NOT NULL COMMENT '模型元数据id',
    `create_id`    bigint(20)                         NOT NULL DEFAULT '0' COMMENT '创建者',
    `create_time`  bigint(20)                         NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_id`    bigint(20)                         NOT NULL DEFAULT '0' COMMENT '修改者',
    `update_time`  bigint(20)                         NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT = '模型版本表';

/**
auth
 */

/**
模型表
 */
CREATE TABLE `ml_model`
(
    `id`               bigint(20) unsigned AUTO_INCREMENT NOT NULL COMMENT 'id',
    `name`             varchar(200)                       NOT NULL DEFAULT '' COMMENT '模型名称',
    `namespace_id`     bigint(20)                         NOT NULL DEFAULT '0' COMMENT '命名空间id',
    `description`      text                               NOT NULL COMMENT '描述信息',
    `version`          bigint(20)                         NOT NULL DEFAULT '0' COMMENT '默认版本',
    `deployment_state` int(10)                            NOT NULL DEFAULT '0' COMMENT '发布版本 0: 未知, 1:已经发布, 2:未发布',
    `create_id`        bigint(20)                         NOT NULL DEFAULT '0' COMMENT '创建者',
    `create_time`      bigint(20)                         NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_id`        bigint(20)                         NOT NULL DEFAULT '0' COMMENT '修改者',
    `update_time`      bigint(20)                         NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT = '模型表';

/**
模型元数据表

data 中有以下数据:
`disable_early_stop`     int(10)                            NOT NULL DEFAULT '0' COMMENT '禁用早期停止 0:false 1:true',
`optimization_objective` text                               NOT NULL DEFAULT '' COMMENT '模型优化的目标函数',
`pre_recall_value` varchar(200) NOT NULL DEFAULT '' COMMENT 'optimizationObjectivePrecisionValue',
`recall_value` varchar(200)  NOT NULL DEFAULT '' COMMENT 'optimizationObjectiveRecallValue',
`fraction_split` json  NOT NULL  COMMENT '分数',
`target_column_spec` json NOT NULL DEFAULT '' COMMENT '列的表示形式',
 */
CREATE TABLE `ml_model_meta`
(
    `id`         bigint(20) unsigned AUTO_INCREMENT NOT NULL COMMENT 'id',
    `name`       varchar(200)                       NOT NULL DEFAULT '' COMMENT '元数据名称',
    `type`       int(10)                            NOT NULL DEFAULT '0' COMMENT '元数据类型 0: 未知 1:Tabular(表格)',
    `dataset_id` bigint(20)                         NOT NULL DEFAULT '0' COMMENT '数据集id',
    `data`       json                               NOT NULL COMMENT '相关数据',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT = '模型表';


/**
job

 */
CREATE TABLE `ml_job`
(
    `id`          bigint(20) unsigned AUTO_INCREMENT NOT NULL COMMENT 'id',
    `name`        varchar(200)                       NOT NULL DEFAULT '' COMMENT 'job名称',
    `type`        int(10)                            NOT NULL DEFAULT '0' COMMENT 'job类型 0:未知 1:训练 2:批量预测',
    `state`       int(10)                            NOT NULL DEFAULT '0' COMMENT '状态 0:未指定 1:刚创建 2:正在准备 3:运行中 4:成功完成 5:失败 6:被取消 7:已经取消了 8:已经停止',
    `error_msg`   text                               NOT NULL COMMENT '异常信息',
    `position`    bigint(20)                         NOT NULL DEFAULT '0' COMMENT '坐标',
    `input`       json                               NOT NULL COMMENT '输入',
    `output`      json                               NOT NULL COMMENT '输出',
    `start_time`  bigint(20)                         NOT NULL DEFAULT '0' COMMENT '开始时间',
    `end_time`    bigint(20)                         NOT NULL DEFAULT '0' COMMENT '结束时间',
    `create_time` bigint(20)                         NOT NULL DEFAULT '0' COMMENT '创建时间',
    `update_time` bigint(20)                         NOT NULL DEFAULT '0' COMMENT '更新时间',
    PRIMARY KEY (`id`)
) ENGINE = InnoDB
  DEFAULT CHARSET = utf8mb4 COMMENT = '模型表';
