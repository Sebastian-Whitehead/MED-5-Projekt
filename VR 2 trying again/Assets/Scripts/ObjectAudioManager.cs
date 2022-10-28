using System;
using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[RequireComponent(typeof(AudioSource))]
public class ObjectAudioManager : MonoBehaviour
{
    
    
    public AudioClip[] soundList = new AudioClip[2];

    private AudioSource _soundSource;
    
    void Start()
    {
        _soundSource = gameObject.GetComponent<AudioSource>();
    }

    public void playSoundFromObject(int index)
    {
        _soundSource.clip = soundList[index];
        _soundSource.Play();
    }

    public void playSoundFromObject(int index, float volume)
    {
        _soundSource.PlayOneShot(soundList[index], volume);
    }

    public void playSoundFromObject(AudioClip soundClip)
    {
        _soundSource.clip = soundClip;
        _soundSource.Play();
    }

    public void playSoundFromObject(AudioClip soundClip, float volume)
    {
        _soundSource.PlayOneShot(soundClip, volume);
    }
}
