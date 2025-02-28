# Copyright 2020 Open Source Robotics Foundation, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#
# Get patterns for output filtering for CycloneDDS RMW.
#
# :param output_patterns: patterns that will be used to identify console
#   output generated by CycloneDDS.
# :type output_filter: string
#
# @public
#
macro(get_rmw_cyclonedds_output_filter output_patterns)
  if(NOT "${ARGN}" STREQUAL "")
    message(FATAL_ERROR "get_rmw_cyclonedds_output_filter() called with "
      "unused arguments: ${ARGN}")
  endif()

  set(${output_patterns} ".*using network interface \\w+ \\(.*\\) selected arbitrarily from:.*")
endmacro()
