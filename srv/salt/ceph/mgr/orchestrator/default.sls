# Immediately after deploying ceph-mgr, it takes a few seconds for the various
# modules to become available.  If we don't wait for this, the subsequent
# `ceph mgr module enable deepsea` and other commands will fail.
wait for mgr to be available:
  module.run:
  - name: retry.cmd
  - kwargs:
      'cmd': 'test "$(ceph mgr dump | jq .available)" = "true"'
  - failhard: True

# The following is not necessary since commit 55422589ce in Ceph on 2019-02-07,
# which makes the orchestrator cli module be always on anyway.
# TODO: remove the below once we're testing against a sufficiently recent Ceph
ceph mgr module enable orchestrator_cli:
  cmd.run:
  - failhard: True

ceph mgr module enable deepsea:
  cmd.run:
  - failhard: True

ceph orchestrator set backend deepsea:
  cmd.run:
  - failhard: True

ceph deepsea config-set salt_api_url "{{ salt['pillar.get']('salt_api_url') }}":
  cmd.run:
  - failhard: True

ceph deepsea config-set salt_api_username "{{ salt['pillar.get']('salt_api_username') }}":
  cmd.run:
  - failhard: True

ceph deepsea config-set salt_api_password "{{ salt['pillar.get']('salt_api_password') }}":
  cmd.run:
  - failhard: True

