%%%   Copyright (c) 2014-2016, Klarna AB
%%%
%%%   Licensed under the Apache License, Version 2.0 (the "License");
%%%   you may not use this file except in compliance with the License.
%%%   You may obtain a copy of the License at
%%%
%%%       http://www.apache.org/licenses/LICENSE-2.0
%%%
%%%   Unless required by applicable law or agreed to in writing, software
%%%   distributed under the License is distributed on an "AS IS" BASIS,
%%%   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
%%%   See the License for the specific language governing permissions and
%%%   limitations under the License.
%%%

%% common header file for code generation and generated code.

-ifndef(kpro_common_hrl).
-define(kpro_common_hrl, true).

-ifndef(KAFKA_VERSION).
-define(KAFKA_VERSION, {0,9,0}). %% by default
-endif.

-type kpro_compress_option() :: no_compression | gzip | snappy | lz4.

%% Compression attributes
-define(KPRO_COMPRESS_NONE,   0).
-define(KPRO_COMPRESS_GZIP,   1).
-define(KPRO_COMPRESS_SNAPPY, 2).
-define(KPRO_COMPRESS_LZ4,    3).

-define(KPRO_COMPRESSION_MASK, 7).
-define(KPRO_IS_GZIP_ATTR(ATTR),
        ((?KPRO_COMPRESSION_MASK band ATTR) =:= ?KPRO_COMPRESS_GZIP)).
-define(KPRO_IS_SNAPPY_ATTR(ATTR),
        ((?KPRO_COMPRESSION_MASK band ATTR) =:= ?KPRO_COMPRESS_SNAPPY)).
-define(KPRO_IS_LZ4_ATTR(ATTR),
        ((?KPRO_COMPRESSION_MASK band ATTR) =:= ?KPRO_COMPRESS_LZ4)).

%% some pre-defined default values
-define(KPRO_REPLICA_ID, -1).
-define(KPRO_API_VERSION, 0).
-define(KPRO_MAGIC_BYTE_V0, 0).
-define(KPRO_MAGIC_BYTE_V1, 1).
-define(KPRO_ATTRIBUTES, ?KPRO_COMPRESS_NONE).

%% correlation IDs are 32 bit signed integers.
%% we use 27 bits only, and use the highest 5 bits to be redudant with API key
%% so that the decoder may decode the responses without the need of an extra
%% correlation ID to API key association.
-define(CORR_ID_BITS, 27).
-define(MAX_CORR_ID, 134217727).


-define(incomplete_message, incomplete_message).

-define(IS_KAFKA_PRIMITIVE(T),
        (T =:= int8 orelse T =:= int16 orelse
         T =:= int32 orelse T =:= int64 orelse
         T =:= string orelse T =:= bytes)).

%% https://cwiki.apache.org/confluence/display/KAFKA/
%%       A+Guide+To+The+Kafka+Protocol#AGuideToTheKafkaProtocol-ApiKeys

-define(API_ProduceRequest,           0).
-define(API_FetchRequest,             1).
-define(API_OffsetRequest,            2).
-define(API_MetadataRequest,          3).
-define(API_OffsetCommitRequest,      8).
-define(API_OffsetFetchRequest,       9).
-define(API_GroupCoordinatorRequest, 10).
-define(API_JoinGroupRequest,        11).
-define(API_HeartbeatRequest,        12).
-define(API_LeaveGroupRequest,       13).
-define(API_SyncGroupRequest,        14).
-define(API_DescribeGroupsRequest,   15).
-define(API_ListGroupsRequest,       16).
-define(API_SaslHandshakeRequest,    17).

-define(ALL_API_KEYS,
        [ ?API_ProduceRequest
        , ?API_FetchRequest
        , ?API_OffsetRequest
        , ?API_MetadataRequest
        , ?API_OffsetCommitRequest
        , ?API_OffsetFetchRequest
        , ?API_GroupCoordinatorRequest
        , ?API_JoinGroupRequest
        , ?API_HeartbeatRequest
        , ?API_LeaveGroupRequest
        , ?API_SyncGroupRequest
        , ?API_DescribeGroupsRequest
        , ?API_ListGroupsRequest
        , ?API_SaslHandshakeRequest
        ]).

-define(REQ_TO_API_KEY(Req),
        case Req of
          kpro_ProduceRequest          -> ?API_ProduceRequest;
          kpro_FetchRequest            -> ?API_FetchRequest;
          kpro_OffsetRequest           -> ?API_OffsetRequest;
          kpro_MetadataRequest         -> ?API_MetadataRequest;
          kpro_OffsetCommitRequestV2   -> ?API_OffsetCommitRequest;
          kpro_OffsetCommitRequestV1   -> ?API_OffsetCommitRequest;
          kpro_OffsetCommitRequestV0   -> ?API_OffsetCommitRequest;
          kpro_OffsetFetchRequest      -> ?API_OffsetFetchRequest;
          kpro_GroupCoordinatorRequest -> ?API_GroupCoordinatorRequest;
          kpro_JoinGroupRequest        -> ?API_JoinGroupRequest;
          kpro_HeartbeatRequest        -> ?API_HeartbeatRequest;
          kpro_LeaveGroupRequest       -> ?API_LeaveGroupRequest;
          kpro_SyncGroupRequest        -> ?API_SyncGroupRequest;
          kpro_DescribeGroupsRequest   -> ?API_DescribeGroupsRequest;
          kpro_ListGroupsRequest       -> ?API_ListGroupsRequest;
          kpro_SaslHandshakeRequest    -> ?API_SaslHandshakeRequest
        end).

-define(API_KEY_TO_REQ(ApiKey),
        case ApiKey of
          ?API_ProduceRequest          -> kpro_ProduceRequest;
          ?API_FetchRequest            -> kpro_FetchRequest;
          ?API_OffsetRequest           -> kpro_OffsetRequest;
          ?API_MetadataRequest         -> kpro_MetadataRequest;
          ?API_OffsetCommitRequest     -> [ kpro_OffsetCommitRequestV2
                                          , kpro_OffsetCommitRequestV1
                                          , kpro_OffsetCommitRequestV0
                                          ];
          ?API_OffsetFetchRequest      -> kpro_OffsetFetchRequest;
          ?API_GroupCoordinatorRequest -> kpro_GroupCoordinatorRequest;
          ?API_JoinGroupRequest        -> kpro_JoinGroupRequest;
          ?API_HeartbeatRequest        -> kpro_HeartbeatRequest;
          ?API_LeaveGroupRequest       -> kpro_LeaveGroupRequest;
          ?API_SyncGroupRequest        -> kpro_SyncGroupRequest;
          ?API_DescribeGroupsRequest   -> kpro_DescribeGroupsRequest;
          ?API_ListGroupsRequest       -> kpro_ListGroupsRequest;
          ?API_SaslHandshakeRequest    -> kpro_SaslHandshakeRequest
        end).

-define(API_KEY_TO_RSP(ApiKey),
        case ApiKey of
          ?API_ProduceRequest          -> kpro_ProduceResponse;
          ?API_FetchRequest            -> kpro_FetchResponse;
          ?API_OffsetRequest           -> kpro_OffsetResponse;
          ?API_MetadataRequest         -> kpro_MetadataResponse;
          ?API_OffsetCommitRequest     -> kpro_OffsetCommitResponse;
          ?API_OffsetFetchRequest      -> kpro_OffsetFetchResponse;
          ?API_GroupCoordinatorRequest -> kpro_GroupCoordinatorResponse;
          ?API_JoinGroupRequest        -> kpro_JoinGroupResponse;
          ?API_HeartbeatRequest        -> kpro_HeartbeatResponse;
          ?API_LeaveGroupRequest       -> kpro_LeaveGroupResponse;
          ?API_SyncGroupRequest        -> kpro_SyncGroupResponse;
          ?API_DescribeGroupsRequest   -> kpro_DescribeGroupsResponse;
          ?API_ListGroupsRequest       -> kpro_ListGroupsResponse;
          ?API_SaslHandshakeRequest    -> kpro_SaslHandshakeResponse
        end).

-define(CONSUMER_GROUP_STRUCTS, [ kpro_ConsumerGroupProtocolMetadata
                                , kpro_ConsumerGroupMemberAssignment
                                ]).

%% Error code macros, from:
%% https://github.com/apache/kafka/blob/0.9.0/clients/src/
%%       main/java/org/apache/kafka/common/protocol/Errors.java

-define(EC_UNKNOWN,                      'UnknownError').                   % -1
-define(EC_NONE,                         'no_error').                       %  0
-define(EC_OFFSET_OUT_OF_RANGE,          'OffsetOutOfRange').               %  1
-define(EC_CORRUPT_MESSAGE,              'CorruptMessage').                 %  2
-define(EC_UNKNOWN_TOPIC_OR_PARTITION,   'UnknownTopicOrPartition').        %  3
-define(EC_INVALID_MESSAGE_SIZE,         'InvalidMessageSize').             %  4
-define(EC_LEADER_NOT_AVAILABLE,         'LeaderNotAvailable').             %  5
-define(EC_NOT_LEADER_FOR_PARTITION,     'NotLeaderForPartition').          %  6
-define(EC_REQUEST_TIMED_OUT,            'RequestTimedOut').                %  7
-define(EC_BROKER_NOT_AVAILABLE,         'BrokerNotAvailable').             %  8
-define(EC_REPLICA_NOT_AVAILABLE,        'ReplicaNotAvailable').            %  9
-define(EC_MESSAGE_TOO_LARGE,            'MessageTooLarge').                % 10
-define(EC_STALE_CONTROLLER_EPOCH,       'StaleControllerEpoch').           % 11
-define(EC_OFFSET_METADATA_TOO_LARGE,    'OffsetMetadataTooLarge').         % 12
-define(EC_NETWORK_EXCEPTION,            'NetworkException').               % 13
-define(EC_GROUP_LOAD_IN_PROGRESS,       'GroupLoadInProgress').            % 14
-define(EC_GROUP_COORDINATOR_NOT_AVAILABLE,
        'GroupCoordinatorNotAvailable').                                    % 15
-define(EC_NOT_COORDINATOR_FOR_GROUP,    'NotCoordinatorForGroup').         % 16
-define(EC_INVALID_TOPIC_EXCEPTION,      'InvalidTopicException').          % 17
-define(EC_MESSAGE_LIST_TOO_LARGE,       'MessageListTooLargeException').   % 18
-define(EC_NOT_ENOUGH_REPLICAS,          'NotEnoughReplicasException').     % 19
-define(EC_NOT_ENOUGH_REPLICAS_AFTER_APPEND,
        'NotEnoughReplicasAfterAppendException').                           % 20
-define(EC_INVALID_REQUIRED_ACKS,        'InvalidRequiredAcks').            % 21
-define(EC_ILLEGAL_GENERATION,           'IllegalGeneration').              % 22
-define(EC_INCONSISTENT_GROUP_PROTOCOL,  'InconsistentGroupProtocol').      % 23
-define(EC_INVALID_GROUP_ID,             'InvalidGroupId').                 % 24
-define(EC_UNKNOWN_MEMBER_ID,            'UnknownMemberId').                % 25
-define(EC_INVALID_SESSION_TIMEOUT,      'InvalidSessionTimeout').          % 26
-define(EC_REBALANCE_IN_PROGRESS,        'RebalanceInProgress').            % 27
-define(EC_INVALID_COMMIT_OFFSET_SIZE,   'InvalidCommitOffsetSize').        % 28
-define(EC_TOPIC_AUTHORIZATION_FAILED,   'TopicAuthorizationFailed').       % 29
-define(EC_GROUP_AUTHORIZATION_FAILED,   'GroupAuthorizationFailed').       % 30
-define(EC_CLUSTER_AUTHORIZATION_FAILED, 'ClusterAuthorizationFailed').     % 31
-define(EC_UNSUPPORTED_SASL_MECHANISM,   'UnsupportedSaslMechanism').       % 33
-define(EC_ILLEGAL_SASL_STATE,           'IllegalSaslState').               % 34

-endif.

