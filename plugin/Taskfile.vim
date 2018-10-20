if exists("g:loaded_Taskfile")
        finish
endif
let g:loaded_Taskfile = 1

let s:PluginName = "Taskfile.nvim"
let s:taskList = [""]
let s:TaskfileWindow = 0

function! s:FileExists(filepath)
        if filereadable(a:filepath)
                return 1
        else
                return 0
        endif
endfunction

function! Taskfile#Run(...)
        let filepath = s:GetTaskfileAbsoluteFilepath()
        if s:FileExists(filepath) == 0
                echo "No Taskfile found"
        else
                let task = get(a:, 1, "")
                let cmd =  s:GetTaskfileAbsoluteFilepath() . " " . task
                call s:ExecExternalCommand(cmd)
        endif
endfunction

function! Taskfile#Reload()
        " TODO Cache Taskfile tasks and only reload the cache when this
        " function fires
endfunction

function! Taskfile#List()
        let cfg = s:GetAllTasks()
        let cmd = s.GetTaskfileFilename()
        call s:ExecExternalCommand(cmd)
endfunction

function! s:OnTermEventHandler(job_id, data, event) dict
        if a:event == 'stdout'
                " do nothing
        elseif a:event == 'stderr'
                execute s:TaskfileWindow . "windo startinsert!"
        elseif a:data == 0
                execute s:TaskfileWindow . "windo startinsert!"
        else
                execute s:TaskfileWindow . "windo startinsert!"
        endif
endfunction

function! s:OnJobEventHandler(job_id, data, event) dict
        if a:event == 'stdout'
                let str = self.shell.' stdout: '.join(a:data)
        elseif a:event == 'stderr'
                let str = self.shell.' stderr: '.join(a:data)
        else
                let str = self.shell.' finished'
        endif
        echom str
endfunction

let s:termEventCallbacks = {
        \ 'on_stdout': function('s:OnTermEventHandler'),
        \ 'on_stderr': function('s:OnTermEventHandler'),
        \ 'on_exit': function('s:OnTermEventHandler')
\ }

let s:jobEventCallbacks = {
        \ 'on_stdout': function('s:OnJobEventHandler'),
        \ 'on_stderr': function('s:OnJobEventHandler'),
        \ 'on_exit': function('s:OnJobEventHandler')
\ }

function! s:taskListCompletion(ArgLead, CmdLine, CursorPos)
        let filepath = s:GetTaskfileAbsoluteFilepath()
        if s:FileExists(filepath) == 0
                return ""
        endif
        let s:taskList = s:GetAllTasks()
        return filter(s:taskList, 'v:val =~ "^'. a:ArgLead .'"')
endfunction

function! s:GetAllTasks()
        let filepath = s:GetTaskfileAbsoluteFilepath()
        let tasklist = systemlist(filepath . " __show_tasks")
        return tasklist
endfunction

function! s:GetTaskfileAbsoluteFilepath()
        let filepath = getcwd() . "/" . s:GetTaskfileFilename()
        return filepath
endfunction

function! s:GetTaskfileFilename()
        return "Taskfile"
endfunction

function! s:ExecExternalCommand(command)
        if has("nvim") == 1
                if exists("g:TaskfileAsynchronous")
                        call jobstart(["bash", "-c", a:command])
                else
                        execute "!" . a:command
                endif
        elseif v:version >= 800
                if exists("g:TaskfileAsynchronous")
                        call job_start("bash -c " . a:command)
                else
                        execute "!" . a:command
                endif
        else
                if exists("g:TaskfileAsynchronous")
                        silent execute "!" . a:command
                else
                        execute "!" . a:command
                endif
        endif
endfunction

function! s:GetBasename(...)
        let buffername = bufname("%")
        let filepath = get(a:, 1, buffername)
        return fnamemodify(filepath, ":t")
endfunction

function! s:ReadfileAsString(filepath)
        return readfile(a:filepath)
endfunction

function! s:GetCurrentFile()
        return expand("%")
endfunction

command! -bang -complete=customlist,s:taskListCompletion -nargs=* Task call Taskfile#Run(<f-args>)

