# DrainerBug

This is a minimal app to help try to reproduce behaviour I am seeing in my app.

## Steps to reproduce:

Open 4 separate shells, in one write:

```sh
watch ps -a
````

This will let you see the pids of running processes.

Then start this server in the second shell:
```sh
iex -S mix phx.server
```

Now you should see the pid of the erlang process appear in the first shell. Now you can use that to create the command to send a sigterm to the BEAM, like so:

```sh
kill -15 THE_PID_HERE
```

Don't run this yet, just have it ready.

Now in the final tab you may run:

```sh
mix run load_test.exs
```

This will send 10 requests per second to `/`. Let it run for a while and then execute the `kill -15` command to sigterm the running app.

You should see that the sigterm gets recognised by platform, that draining begins, but that we see an error because some requests are accepted _after_ the sigterm has been received.
